[
  {
    "name": "${container_name}",
    "image": "${docker_image}",
    "essential": true,
    "cpu": 256,
    "memory": 512,
    "portMappings": [
      {
        "containerPort": 80,
        "hostPort": ${port_num},
        "protocol": "tcp"
      }
    ]
  }
]
