variable "cidr_block" {
  type = string
  default = "192.168.0.0/16"
}

variable "http_port" {
  description = "The port to use for HTTP"
  type        = number
  default     = 4646
}

variable "rpc_port" {
  description = "The port to use for RPC"
  type        = number
  default     = 4647
}

variable "serf_port" {
  description = "The port to use for Serf"
  type        = number
  default     = 4648
}

