# 0.9.2 (Nov 16, 2023)
* Enable automatic compression for site assets and `env.json`.

# 0.9.1 (May 15, 2023)
* Fixed default cache policy. Changed to `Managed-CachingOptimized`.
* Fixed default response headers policy. Changed to `Managed-CORS-with-preflight-and-SecurityHeadersPolicy`.

# 0.9.0 (May 15, 2023)
* Allow configuration of Cache Policy. Default: `CachingOptimized`
* Allow configuration of Response Headers Policy. Default: `CORS-with-preflight-and-SecurityHeadersPolicy`
* Add variables `min_ttl`, `default_ttl`, and `max_ttl` to configure caching.
