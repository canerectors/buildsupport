FOR /f "tokens=*" %%i IN ('docker images -f "dangling=true" -q') DO docker rmi -f %%i