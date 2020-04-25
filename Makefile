all: git  


git:
	git config --global user.email "avarakin@gmail.com"
	git config --global user.name "Alex Varakin"
	git config credential.helper 'cache --timeout=30000'
