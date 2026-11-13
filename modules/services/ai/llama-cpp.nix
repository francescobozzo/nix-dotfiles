{ ... }:
{
  flake.modules.nixos.ai =
    { pkgs, lib, ... }:
    {
      _module.args.fbLlamaCpp =
        (pkgs.unstable.llama-cpp.override {
          rocmSupport = true;
          rocmGpuTargets = [ "gfx1151" ];
        }).overrideAttrs
          (oldAttrs: rec {
            version = "12329";
            commit = "0d69255";
            src = pkgs.fetchFromGitHub {
              owner = "ggml-org";
              repo = "llama.cpp";
              tag = "b${version}";
              hash = "sha256-fZopxE+CPVmnuswxRUZZQYaGjLh7au1euWZNHbKel60=";
              leaveDotGit = true;
              postFetch = ''
                git -C "$out" rev-parse --short HEAD > $out/COMMIT
                find "$out" -name .git -print0 | xargs -0 rm -rf
              '';
            };
            npmRoot = "tools/ui";
            npmDepsHash = "sha256-0OJIueUN5oD/V2NtVcXTiRW59u2tJIG3OxW8aJ8JDBY=";

            # The nixpkgs recipe pins these independently of version and src.
            cmakeFlags =
              (builtins.filter (
                flag: !(lib.hasPrefix "-DLLAMA_BUILD_NUMBER" flag) && !(lib.hasPrefix "-DLLAMA_BUILD_COMMIT" flag)
              ) oldAttrs.cmakeFlags)
              ++ [
                "-DLLAMA_BUILD_NUMBER:STRING=${version}"
                "-DLLAMA_BUILD_COMMIT:STRING=${commit}"
                "-DLLAMA_HIP_UMA=ON" # unified memory
              ];

            preConfigure = ''
              pushd ${npmRoot}
              LLAMA_BUILD_NUMBER=${version} npm run build
              popd
            '';

            # This newer source adds a Python test that imports torch.
            disabledTests = (oldAttrs.disabledTests or [ ]) ++ [ "test-kv-cache-scales" ];

            # Mirror the Strix Halo toolbox HIP tuning: pin the ROCm path explicitly and
            # raise the local unroll threshold for gfx1151 kernels.
            cmakeFlagsArray = (oldAttrs.cmakeFlagsArray or [ ]) ++ [
              "-DCMAKE_HIP_FLAGS=--rocm-path=${pkgs.rocmPackages.clr} -mllvm --amdgpu-unroll-threshold-local=600"
            ];
          });
    };
}
