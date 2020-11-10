job "ratings-catalog" {
  datacenters = ["us-east-1a", "us-east-1b", "us-east-1c"]

  type = "service"

  update {
    max_parallel = 1
    min_healthy_time = "10s"
    healthy_deadline = "3m"
    progress_deadline = "10m"
    auto_revert = false
    canary = 0
  }
  group "api" {
    count = 2

    restart {
      attempts = 2
      interval = "30m"
      delay = "15s"
      mode = "fail"
    }

    network {
      port "http" {}
    }

    task "service" {
      driver = "docker"
      config {
        image = "pleymo/ratings-catalog:1.0"
        ports = ["http"]
        network_mode = "host"
      }

      resources {
        cpu    = 500 # 500 MHz
        memory = 256 # 256MB
      }
    }

    service {
      name = "ratings-catalog"
      tags = ["urlprefix-/ratings strip=/ratings", "us-east-1"]
      port     = "http"

      check {
        type     = "http"
        path     = "/health"
        interval = "10s"
        timeout  = "2s"
      }
    }
  }
}
