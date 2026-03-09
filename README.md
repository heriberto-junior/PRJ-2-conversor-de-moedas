# Conversor de Moedas Cobol GNU + YAML + CI/CD (Github Actions)

Nesse projeto foi desenvolvido um programa Cobol que utiliza como entrada o arquivo cotacao.txt para fazer conversão de moedas de acordo com a moeda BRL escolhida.

Nele é possível selecionar 6 tipos de moeda para conversa.

O projeto utiliza YAML pra fazer a compilação e execução do Cobol GNU, onde o código fonte é convertido para C para que possa executar (função do Cobol GNU).

Nele é possível ver uma fácil utilização de CI/CD tendo em vista a integração continua e a entrega contínua, porém se torna pouco prático para utilizar visto que para cada execução é necessária uma compilação e uma execução.

Com isso separei a compilação da execução, mas mesmo na execução o é necessária a instalação do update do Cobol GNU e da libcob4, fazendo com que o processo leve de 16 a 24 segundos.
