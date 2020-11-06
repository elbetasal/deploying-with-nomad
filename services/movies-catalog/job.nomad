job "movie-catalog" {
  # The "region" parameter specifies the region in which to execute the job.
  # If omitted, this inherits the default region name of "global".
  # region = "global"
  #
  # The "datacenters" parameter specifies the list of datacenters which should
  # be considered when placing this task. This must be provided.
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
//  # The migrate stanza specifies the group's strategy for migrating off of
//  # draining nodes. If omitted, a default migration strategy is applied.
//  #
//  # For more information on the "migrate" stanza, please see
//  # the online documentation at:
//  #
//  #     https://www.nomadproject.io/docs/job-specification/migrate.html
//  #
//  migrate {
//    # Specifies the number of task groups that can be migrated at the same
//    # time. This number must be less than the total count for the group as
//    # (count - max_parallel) will be left running during migrations.
//    max_parallel = 1
//
//    # Specifies the mechanism in which allocations health is determined. The
//    # potential values are "checks" or "task_states".
//    health_check = "checks"
//
//    # Specifies the minimum time the allocation must be in the healthy state
//    # before it is marked as healthy and unblocks further allocations from being
//    # migrated. This is specified using a label suffix like "30s" or "15m".
//    min_healthy_time = "10s"
//
//    # Specifies the deadline in which the allocation must be marked as healthy
//    # after which the allocation is automatically transitioned to unhealthy. This
//    # is specified using a label suffix like "2m" or "1h".
//    healthy_deadline = "5m"
//  }
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
        image = "pleymo/movie-catalog:latest"
        ports = ["http"]
      }

      resources {
        cpu    = 500 # 500 MHz
        memory = 256 # 256MB
      }
    }

    service {
      name = "movies-catalog"
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
