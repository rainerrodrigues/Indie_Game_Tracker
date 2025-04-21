FROM julia:1.10

WORKDIR /app

# Install required Julia packages
COPY Project.toml Manifest.toml ./
RUN julia -e 'using Pkg; Pkg.instantiate()'

COPY . .

EXPOSE 8000

CMD ["julia", "-e", "using Genie; Genie.loadapp(); Genie.up(8000, host=\"0.0.0.0\")"]
