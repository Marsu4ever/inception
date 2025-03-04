all: mariadb_data wordpress_data
	make images
	make up

images:
	docker-compose -f srcs/docker-compose.yml build

up:
	docker compose -f srcs/docker-compose.yml up -d

mariadb_data:
	mkdir -p /home/mkorpela/data/mariadb

wordpress_data:
	mkdir -p /home/mkorpela/data/wordpress

down:
	docker compose -f srcs/docker-compose.yml down

clean: 
	docker compose -f srcs/docker-compose.yml down --rmi all -v

fclean: clean
	sudo rm -rf /home/mkorpela/data/mariadb
	sudo rm -rf /home/mkorpela/data/wordpress
	sudo rm -rf /home/mkorpela/data
	docker system prune -f --volumes

re: fclean all

.PHONY: all clean fclean re up down mariadb_data wordpress_data
