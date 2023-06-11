.DEFAULT_GOAL := help

alp: ## Shwo alp
	cat /var/log/nginx/access.log | alp json --sort sum -r -m "/posts/[0-9]+, /@\w,/image/\d+" -o count,method,uri,min,avg,max,sum

nginx-restart: ## restart nginx
	sudo cp webapp/etc/nginx/nginx.conf /etc/nginx/nginx.conf
	sudo cp webapp/etc/nginx/conf.d/default.conf /etc/nginx/sites-available/isucon.conf
	sudo nginx -t
	sudo mv /var/log/nginx/access.log /var/log/nginx/access.log.`date +%Y%m%d%H%M%S`
	sudo systemctl restart nginx

nginx-log: ## tail nginx access.log
	@sudo tail -f /var/log/nginx/access.log

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
