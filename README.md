# Trabajo Práctico de Programación Avanzada (UTN-FRM)
# Juego de cartas

Esta es la API de una aplicación del juego de cartas UNO que se puede jugar de a dos personas. Esta parte está hecha con Ruby on Rails y el SGBD PostgreSQL.

La parte de Front-End se encuentra en este repositorio: https://github.com/JulietaEsains/uno_card_game_react

## End-points y requests

Todos los end-points esperan que los datos en el cuerpo de la solicitud estén en formato JSON, y devuelven datos en formato JSON en el cuerpo de la respuesta.

## Usuario

### Iniciar sesión

El end-point authentication#login (url/auth/login) espera un POST con credenciales que identifican a un usuario previamente registrado:

```
{
	"email": "ejemplo@email.com",
	"password": "contraseñaEjemplo"
}
```

Si la solicitud tiene éxito, la respuesta tendrá un estado HTTP de 200 (OK) y el cuerpo contendrá el token necesario para que el usuario autentique otras solicitudes:

```
{
	"token": "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjozLCJleHAiOjE2NTYzNzI3ODF9.iPOR3KdJ790dSeRehVSTufN2Gxjo7V8S3Fp2patt6Bo"
}
```

### Crear usuario

El end-point users#create (url/users) espera un POST con credenciales que identifican a un usuario por crearse:

```
{
	"name": "Nombre Ejemplo",
	"username": "ejemplo123",
	"email": "ejemplo@email.com",
	"password": "contraseñaEjemplo"
}
```

Si la solicitud tiene éxito, la respuesta tendrá un estado HTTP de 201 (Creado) y la respuesta contendrá los datos del nuevo usuario:

```
{
	"user": {
		"id": 1,
		"name": "Nombre Ejemplo",
		"username": "ejemplo123",
		"email": "ejemplo@email.com",
		"password_digest": "$2a$12$vch30zpT5ACf25yL9Bb16OdZGAJ0W3yXWAUN83OtTyF/BoBC61WFq",
		"created_at": "2022-06-20T23:32:00.954Z",
		"updated_at": "2022-06-20T23:32:00.954Z"
	}
}
```

### Actualizar datos de usuario

El end-point users#update (url/users/:id) espera un PATCH con los datos del perfil del usuario modificados (o no):

```
{
	"name": "Nombre Nuevo",
	"username": "ejemplo123",
	"email": "ejemplo@email.com"
}
```

Si la solicitud tiene éxito, la respuesta tendrá un estado HTTP de 200 (OK) y la respuesta contendrá los datos actualizados:

```
{
	"user": {
		"id": 1,
		"name": "Nombre Nuevo",
		"username": "ejemplo123",
		"email": "ejemplo@email.com",
		"password_digest": "$2a$12$vch30zpT5ACf25yL9Bb16OdZGAJ0W3yXWAUN83OtTyF/BoBC61WFq",
		"created_at": "2022-06-20T23:32:00.954Z",
		"updated_at": "2022-06-20T23:32:00.954Z"
	}
}
```

## Partida

Todas las solicitudes de las partidas (games) deben incluir un token de autenticación en la cabecera o serán rechazadas con un estado 401 (No autorizado).

Las partidas están asociadas con usuarios (player_1 y player_2). Los end-points traerán una partida sólo si el usuario asociado al token de la cabecera es uno de esos dos usuarios. Sino, la respuesta tendrá el estado 404 (No encontrado), excepto por la acción index que retornaría un arreglo de partidas vacío.

# Mostrar partidas de un usuario

El end-point games#index (url/games) es un GET y devuelve todas las partidas asociadas a un usuario. El cuerpo de la respuesta contendrá un arreglo de partidas:

```
{
	"games": [
		{
			"id": 1,
			"player_1_id": 1,
			"player_2_id": 2,
			"player_1_wins": 2,
			"player_2_wins": 1,
			"player_1_hand": [
				"1B",
				"W",
				"7B",
				"0Y",
				"6Y"
			],
			"player_2_hand": [
				"2G",
				"3B",
				"_Y",
				"9B",
				"skipB",
				"8R"
			],
			"played_cards_pile": [
				"6G",
				"6G",
				"4G",
				"8G"
			],
			"draw_card_pile": [
				"_Y",
				"D2G",
				"D2B",
				"3R",
				"8Y",
				"D4W",
				"5B",
				"W",
				"1B",
				"9Y",
				"0B",
				"3B",
				"3Y",
				"6B",
				"7B",
				"4B",
				"_B",
				"9G",
				"D2R",
				"_R",
				"0R",
				"skipG",
				"_G",
				"1Y",
				"_R",
				"3G",
				"D2Y",
				"D4W",
				"7R",
				"5R",
				"2R",
				"5G",
				"9B",
				"1R",
				"skipG",
				"D2R",
				"2Y",
				"5Y",
				"6Y",
				"D4W",
				"3R",
				"2R",
				"0G",
				"9R",
				"3G",
				"5B",
				"W",
				"2B",
				"9G",
				"6R",
				"8B",
				"8Y",
				"2B",
				"7R",
				"1Y",
				"5G",
				"D4W",
				"1G",
				"5Y",
				"9R",
				"skipB",
				"7Y",
				"4Y",
				"5R",
				"7G",
				"7G",
				"skipR",
				"7Y",
				"_G",
				"8R",
				"9Y",
				"1G",
				"3Y",
				"8G",
				"4G",
				"D2G",
				"D2Y",
				"skipR",
				"6B",
				"4Y",
				"D2B",
				"skipY",
				"2G",
				"skipY",
				"4B",
				"4R",
				"1R",
				"_B",
				"2Y",
				"6R",
				"8B",
				"4R",
				"W"
			],
			"turn": "2",
			"created_at": "2022-06-29T08:07:39.560Z",
			"updated_at": "2022-06-29T08:11:32.129Z"
		}
	]
}
```

### Crear partida

El end-point games#create (url/games) espera un POST con un cuerpo de solicitud vacío. Si la solicitud tiene éxito, la respuesta tendrá un estado HTTP de 201 (Creado) y el cuerpo contendrá los datos de la partida creada con el player_1 establecido para el usuario que realizó esta solicitud:

```
{
	"game": {
		"id": 3,
		"player_1_id": 1,
		"player_2_id": null,
		"player_1_wins": 0,
		"player_2_wins": 0,
		"player_1_hand": [],
		"player_2_hand": [],
		"played_cards_pile": [],
		"draw_card_pile": [
			"0R",
			"1R",
			"1R",
			"2R",
			"2R",
			"3R",
			"3R",
			"4R",
			"4R",
			"5R",
			"5R",
			"6R",
			"6R",
			"7R",
			"7R",
			"8R",
			"8R",
			"9R",
			"9R",
			"skipR",
			"skipR",
			"_R",
			"_R",
			"D2R",
			"D2R",
			"0G",
			"1G",
			"1G",
			"2G",
			"2G",
			"3G",
			"3G",
			"4G",
			"4G",
			"5G",
			"5G",
			"6G",
			"6G",
			"7G",
			"7G",
			"8G",
			"8G",
			"9G",
			"9G",
			"skipG",
			"skipG",
			"_G",
			"_G",
			"D2G",
			"D2G",
			"0B",
			"1B",
			"1B",
			"2B",
			"2B",
			"3B",
			"3B",
			"4B",
			"4B",
			"5B",
			"5B",
			"6B",
			"6B",
			"7B",
			"7B",
			"8B",
			"8B",
			"9B",
			"9B",
			"skipB",
			"skipB",
			"_B",
			"_B",
			"D2B",
			"D2B",
			"0Y",
			"1Y",
			"1Y",
			"2Y",
			"2Y",
			"3Y",
			"3Y",
			"4Y",
			"4Y",
			"5Y",
			"5Y",
			"6Y",
			"6Y",
			"7Y",
			"7Y",
			"8Y",
			"8Y",
			"9Y",
			"9Y",
			"skipY",
			"skipY",
			"_Y",
			"_Y",
			"D2Y",
			"D2Y",
			"W",
			"W",
			"W",
			"W",
			"D4W",
			"D4W",
			"D4W",
			"D4W"
		],
		"turn": "1",
		"created_at": "2022-06-29T08:47:52.708Z",
		"updated_at": "2022-06-29T08:47:52.708Z"
	}
}
```

### Mostrar partida

El end-point games#show (url/games/:id) es un GET especificando el id de la partida en cuestión. Si la solicitud tiene éxito tendrá un estado de 200 (OK) y el cuerpo contendrá datos de la partida:

```
{
	"game": {
		"id": 1,
		"player_1_id": 1,
		"player_2_id": 2,
		"player_1_wins": 2,
		"player_2_wins": 1,
		"player_1_hand": [
			"1B",
			"W",
			"7B",
			"0Y",
			"6Y"
		],
		"player_2_hand": [
			"2G",
			"3B",
			"_Y",
			"9B",
			"skipB",
			"8R"
		],
		"played_cards_pile": [
			"6G",
			"6G",
			"4G",
			"8G"
		],
		"draw_card_pile": [
			"_Y",
			"D2G",
			"D2B",
			"3R",
			"8Y",
			"D4W",
			"5B",
			"W",
			"1B",
			"9Y",
			"0B",
			"3B",
			"3Y",
			"6B",
			"7B",
			"4B",
			"_B",
			"9G",
			"D2R",
			"_R",
			"0R",
			"skipG",
			"_G",
			"1Y",
			"_R",
			"3G",
			"D2Y",
			"D4W",
			"7R",
			"5R",
			"2R",
			"5G",
			"9B",
			"1R",
			"skipG",
			"D2R",
			"2Y",
			"5Y",
			"6Y",
			"D4W",
			"3R",
			"2R",
			"0G",
			"9R",
			"3G",
			"5B",
			"W",
			"2B",
			"9G",
			"6R",
			"8B",
			"8Y",
			"2B",
			"7R",
			"1Y",
			"5G",
			"D4W",
			"1G",
			"5Y",
			"9R",
			"skipB",
			"7Y",
			"4Y",
			"5R",
			"7G",
			"7G",
			"skipR",
			"7Y",
			"_G",
			"8R",
			"9Y",
			"1G",
			"3Y",
			"8G",
			"4G",
			"D2G",
			"D2Y",
			"skipR",
			"6B",
			"4Y",
			"D2B",
			"skipY",
			"2G",
			"skipY",
			"4B",
			"4R",
			"1R",
			"_B",
			"2Y",
			"6R",
			"8B",
			"4R",
			"W"
		],
		"turn": "2",
		"created_at": "2022-06-29T08:07:39.560Z",
		"updated_at": "2022-06-29T08:11:32.129Z"
	}
}
```

### Unirse a una partida (como jugador 2)

El end-point games#update (url/games/:id) espera un PATCH vacío para unirse a una partida existente.

Si la solicitud tiene éxito, la respuesta tendrá un estado HTTP de 200 (OK) y el cuerpo contendrá los datos de la partida en cuestión:

```
{
	"game": {
		"player_2_id": 2,
		"id": 3,
		"player_1_id": 1,
		"player_1_wins": 0,
		"player_2_wins": 0,
		"player_1_hand": [],
		"player_2_hand": [],
		"played_cards_pile": [],
		"draw_card_pile": [
			"0R",
			"1R",
			"1R",
			"2R",
			"2R",
			"3R",
			"3R",
			"4R",
			"4R",
			"5R",
			"5R",
			"6R",
			"6R",
			"7R",
			"7R",
			"8R",
			"8R",
			"9R",
			"9R",
			"skipR",
			"skipR",
			"_R",
			"_R",
			"D2R",
			"D2R",
			"0G",
			"1G",
			"1G",
			"2G",
			"2G",
			"3G",
			"3G",
			"4G",
			"4G",
			"5G",
			"5G",
			"6G",
			"6G",
			"7G",
			"7G",
			"8G",
			"8G",
			"9G",
			"9G",
			"skipG",
			"skipG",
			"_G",
			"_G",
			"D2G",
			"D2G",
			"0B",
			"1B",
			"1B",
			"2B",
			"2B",
			"3B",
			"3B",
			"4B",
			"4B",
			"5B",
			"5B",
			"6B",
			"6B",
			"7B",
			"7B",
			"8B",
			"8B",
			"9B",
			"9B",
			"skipB",
			"skipB",
			"_B",
			"_B",
			"D2B",
			"D2B",
			"0Y",
			"1Y",
			"1Y",
			"2Y",
			"2Y",
			"3Y",
			"3Y",
			"4Y",
			"4Y",
			"5Y",
			"5Y",
			"6Y",
			"6Y",
			"7Y",
			"7Y",
			"8Y",
			"8Y",
			"9Y",
			"9Y",
			"skipY",
			"skipY",
			"_Y",
			"_Y",
			"D2Y",
			"D2Y",
			"W",
			"W",
			"W",
			"W",
			"D4W",
			"D4W",
			"D4W",
			"D4W"
		],
		"turn": "1",
		"created_at": "2022-06-29T08:47:52.708Z",
		"updated_at": "2022-06-29T08:51:58.129Z"
	}
}
```

## Actualizar una partida

Hay muchas maneras de actualizar una partida, todas ellas esperan un PATCH en el end-point games#update (url/games/:id), con los siguientes fragmentos en el cuerpo de la solicitud según el caso:

### Distribuir cartas iniciales

```
{
	"game": {
		"update_type": "distribute"
	}
}
```

### Robar una carta

```
{
	"game": {
		"update_type": "draw"
	}
}
```

### Colocar una carta en el juego

```
{
	"game": {
		"update_type": "play",
		"card_index": 0
	}
}
```

### Alternar el turno

```
{
	"game": {
		"update_type": "turn"
	}
}
```

### Añadir una victoria a un jugador

```
{
	"game": {
		"update_type": "add win",
		"player": "1"
	}
}
```

### Quitar una victoria a un jugador

```
{
	"game": {
		"update_type": "remove win",
		"player": "1"
	}
}
```

### Reiniciar los mazos como al principio de la partida

```
{
	"game": {
		"update_type": "restart"
	}
}
```

Todas las solicitudes anteriores reciben como respuesta los datos de la partida actualizados.
### 
