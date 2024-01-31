# Connecting to the outside world

Most things pertaining to the homelabe are self contained in the home network, but sometimes you need to share a service out to the internet, and for that we use `cloudflared` that will run in k8s

### Getting the auth files

Since this runs in k8s most of the setup is automated, but we need to populate some credentials so it will function properly

Download `cloudflared` for whatever platform you have and run:
```bash
cloudflared tunnel login
cloudflared tunnel create k8s-tunnel
```

Be sure to populate `CLOUDFLARED_PEM=/path/to/your.pem` and `CLOUDFLARED_JSON_CREDS=/path/to/your.json` in `.env` after this, which will be consumed when deploying the k8s service for cloudflared and turned into secrets