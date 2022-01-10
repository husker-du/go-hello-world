[
  {
    "name": "${container_name}",
    "image": "${docker_image}",
    "essential": true,
    "cpu": 50,
    "memory": 128,
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
