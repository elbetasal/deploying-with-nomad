job "movie-catalog" {
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
        image = "pleymo/movies-catalog:v3.0"
        ports = ["http"]
      }

      resources {
        cpu    = 500 # 500 MHz
        memory = 256 # 256MB
      }
    }

    service {
      name = "movies-catalog"
      tags = ["urlprefix-/movies strip=/movies", "us-east-1"]
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
