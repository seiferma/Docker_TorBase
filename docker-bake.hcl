variable "TOR_VERSION" {
  # renovate: datasource=repology depName=alpine_3_22/tor versioning=loose
  default = "0.4.8.21-r0"
}

variable "TORSOCKS_VERSION" {
  # renovate: datasource=repology depName=alpine_3_22/torsocks versioning=loose
  default = "2.5.0-r0"
}

variable "PRIVOXY_VERSION" {
  # renovate: datasource=repology depName=alpine_3_22/privoxy versioning=loose
  default = "3.0.34-r3"
}

group "default" {
  targets = ["default"]
}

target "default" {
  platforms = ["linux/amd64", "linux/arm64"]
  tags = ["quay.io/seiferma/tor-base:${TOR_VERSION}", "quay.io/seiferma/tor-base:latest"]
  args = {
    TOR_VERSION = "${TOR_VERSION}"
    TORSOCKS_VERSION = "${TORSOCKS_VERSION}"
    PRIVOXY_VERSION = "${PRIVOXY_VERSION}"
  }
}

group "test" {
  targets = ["test"]
}

target "test" {
  inherits = ["default"]
  platforms = ["linux/amd64"]
  tags = ["test-image"]
}