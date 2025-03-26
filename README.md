## cURL Commands

### View metrics
```sh
curl -X GET http://localhost:3000/metrics
```

### Access grafana at 
- url - `http://localhost:3001`
- username - `admin`
- password - `admin`

look for the counter `http_requests_total`

<img width="1728" alt="Screenshot 2025-03-25 at 18 13 13" src="https://github.com/user-attachments/assets/cc6e218c-1ae8-4418-a7d5-a7bb99017e84" />


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

### Viewing logs
```sh
docker logs {your container id}
```

