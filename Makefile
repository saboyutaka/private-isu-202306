.DEFAULT_GOAL := help

nginx-restart: ## restart nginx
	sudo cp webapp/etc/nginx/nginx.conf /etc/nginx/nginx.conf
	sudo cp webapp/etc/nginx/conf.d/default.conf /etc/nginx/sites-available/isucon.conf
	sudo nginx -t
	sudo systemctl restart nginx

nginx-log: ## tail nginx access.log
	@sudo tail -f /var/log/nginx/access.log

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
