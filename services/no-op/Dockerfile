# interpolator replaces templated variables in docker-compose.yaml
FROM dockertemplate/interpolator:v0.1.4 as interpolator
COPY assets .

# this is a no-op service, just used to collect parameters for other services