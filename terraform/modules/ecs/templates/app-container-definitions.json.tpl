[
  {
    "name": "${container_name}",
    "image": "${docker_image}",
    "essential": true,
    "cpu": 100,
    "memory": 256,
    "portMappings": [
      {
        "containerPort": ${port_num},
        "hostPort": 0,
        "protocol": "tcp"
      }
    ],
    "entryPoint": [],
    "volumesFrom": [],
    "links": [],
    "mountPoints": []
  }
]
