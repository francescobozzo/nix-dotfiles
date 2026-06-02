import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

export default function helloWorld(pi: ExtensionAPI) {
  pi.registerCommand("hello", {
    description: "Say hello to someone",
    handler: async (args, ctx) => {
      const name = args?.trim() || "world";
      ctx.ui.notify(`Hello, ${name}! 🌍`, "info");
    },
  });
}
