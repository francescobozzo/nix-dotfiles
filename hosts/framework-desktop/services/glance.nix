{ ... }:
{
  services.glance = {
    enable = true;
    settings = {
      server = {
        host = "0.0.0.0";
        port = 14514;
      };
      pages = [
        {
          name = "Home";
          width = "slim";
          hide-desktop-navigation = true;
          center-vertically = true;
          columns = [
            {
              size = "full";
              widgets = [
                {
                  type = "search";
                  search-engine = "google"; # alias for https://www.google.com/search?q={QUERY}
                  autofocus = true;
                  new-tab = true;
                  bangs = [
                    {
                      title = "Nixpkgs github issues";
                      shortcut = "!nh";
                      url = "https://github.com/NixOS/nixpkgs/issues?q=sort%3Aupdated-desc%20is%3Aissue%20is%3Aopen%20{QUERY}";
                    }
                    {
                      title = "MyNixOS documentation";
                      shortcut = "!mn";
                      url = "https://mynixos.com/search?q={QUERY}";
                    }
                    {
                      title = "Youtube";
                      shortcut = "!yt";
                      url = "https://www.youtube.com/results?search_query={QUERY}";
                    }
                  ];
                }
                {
                  type = "monitor";
                  cache = "1m";
                  title = "services";
                  sites = [
                    # icons: https://github.com/glanceapp/glance/blob/main/docs/configuration.md#icons
                    {
                      title = "whoami";
                      url = "https://whoami.fbozzo.dpdns.org";
                      icon = "mdi:account";
                    }
                    {
                      title = "pihole";
                      url = "https://pihole.fbozzo.dpdns.org";
                      icon = "di:pi-hole";
                    }
                    {
                      title = "open-webui";
                      url = "https://webui.fbozzo.dpdns.org";
                      icon = "di:open-webui";
                    }
                    {
                      title = "hass";
                      url = "https://hass.fbozzo.dpdns.org";
                      icon = "di:home-assistant";
                    }
                    {
                      title = "ollama";
                      url = "https://llm.fbozzo.dpdns.org";
                      icon = "di:ollama";
                    }
                    {
                      title = "glance";
                      url = "https://glance.fbozzo.dpdns.org";
                      icon = "di:glance";
                    }
                    {
                      title = "uptime-kuma";
                      url = "https://status.fbozzo.dpdns.org";
                      icon = "di:uptime-kuma";
                    }
                  ];
                }
              ];
            }
            {
              size = "small";
              widgets = [
                {
                  type = "clock";
                  hour-format = "24h";
                  timezones = [
                    {
                      timezone = "America/Los_Angeles";
                      label = "Seattle";
                    }
                    {
                      timezone = "America/New_York";
                      label = "New York";
                    }
                    {
                      timezone = "Asia/Kolkata";
                      label = "Bangalore";
                    }
                  ];
                }
                {
                  type = "server-stats";
                  servers = [
                    {
                      type = "local";
                      name = "neos";
                    }
                  ];
                }
                {
                  type = "markets";
                  markets = [
                    {
                      symbol = "VWCE.MI";
                      name = "All-World";
                    }
                    {
                      symbol = "AMZN";
                      name = "Amazon";
                    }
                    {
                      symbol = "EUR=X";
                      name = "Dollar";
                    }
                    {
                      symbol = "BTC-EUR";
                      name = "Bitcoin";
                    }
                  ];
                }
              ];
            }
          ];
        }
      ];
    };
  };
}
