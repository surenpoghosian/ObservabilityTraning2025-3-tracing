## Run the project first

```sh
docker compose up --build
```

### Access Jaeger at
- url - `http://localhost:16686`

look for service `observability-tracing`

<img width="1728" alt="Screenshot 2025-03-26 at 18 05 21" src="https://github.com/user-attachments/assets/be1a5fc1-255a-4fe0-b906-5fa15e6ec64f" />

### Access Grafana at 
- url - `http://localhost:3001`
- username - `admin`
- password - `admin`

look for the metric `http_requests_total`

<img width="1728" alt="Screenshot 2025-03-25 at 18 13 13" src="https://github.com/user-attachments/assets/cc6e218c-1ae8-4418-a7d5-a7bb99017e84" />

### View logs
```sh
docker logs {your container id}
```

### View metrics
```sh
curl -X GET http://localhost:3000/metrics
```

### Get all users
```sh
curl -X GET http://localhost:3000/users
```

### Create a new user
```sh
curl -X POST http://localhost:3000/users \
     -H "Content-Type: application/json" \
     -d '{"name": "John Doe", "email": "john@example.com"}'
```

### Get a user by ID
```sh
curl -X GET http://localhost:3000/users/1
```

### Update a user
```sh
curl -X PUT http://localhost:3000/users/1 \
     -H "Content-Type: application/json" \
     -d '{"name": "Jane Doe", "email": "jane@example.com"}'
```

### Delete a user
```sh
curl -X DELETE http://localhost:3000/users/1
```

### Health check
```sh
curl -X GET http://localhost:3000/health
```



