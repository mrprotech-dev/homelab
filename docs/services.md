# Services

## Pi-hole (CT 100)

Network-wide ad and tracker blocking. Installed with the Proxmox community script. The router hands it out as the only DNS server. Upstream DNS is a public resolver.

## Open WebUI (CT 101)

ChatGPT-style interface for local models. The models run in Ollama on the gaming PC (RTX 5070, 12 GB VRAM), reached on port 11434.

Lessons learned:
- Ollama only listens on `127.0.0.1` by default. Setting `OLLAMA_HOST=0.0.0.0` as a system variable makes it reachable from the server.
- Models larger than VRAM spill onto the CPU and slow down a lot. `ollama ps` shows the CPU/GPU split; a 9B model fits fully on the GPU, a 30B MoE model ran 46% CPU / 54% GPU.
- Qwen3's thinking mode can overflow a 4096-token context. Raising the context or using `/no_think` fixed long stalls.

## Homepage (CT 102)

Dashboard showing every service with live status. Uses a read-only Proxmox API token (`PVEAuditor` role) and a Pi-hole app password for its widgets. The build needed 4 GB RAM temporarily; the container runs on 1 GB afterwards. See [`configs/homepage/services.example.yaml`](../configs/homepage/services.example.yaml).

## Grafana (CT 103)

Dashboard for my trading bot, which runs 24/7 on a cloud VM. A job in the container pulls the bot's logs over SSH every minute using a key restricted to read-only access.

## Jarvis (CT 104)

Always-on AI assistant.
- **Agent:** Hermes Agent, with Google Gemini (free tier) as the model.
- **Chat:** a Discord bot with channels for lab status, calendar and coding.
- **Tools:** Proxmox status (API token with no access to the vault VM), calendars through iCal feeds, Grafana P&L, weather and web search.
- **Search:** self-hosted SearXNG, because Google's search API is closed to new users and Brave's needs a card.
- Runs as systemd services that start on boot. Answers lab and calendar questions in about 7 seconds.

## SearXNG (CT 105)

Private metasearch engine that queries several search engines without tracking. Used by Jarvis for web search.

## Sandbox VM (200)

Ubuntu desktop for opening untrusted files and links. Proxmox firewall allows the internet but blocks the home network. Snapshots let me roll back after testing anything risky. Accessed with Ubuntu's Remote Login (RDP) or SPICE.

## Vault VM (201)

Ubuntu desktop used only for sensitive accounts. Bookmarks only, no extra software, no Remote Desktop; reached only through the Proxmox SPICE console.
