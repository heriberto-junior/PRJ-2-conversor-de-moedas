# [ENG] Currency Converter - GNU COBOL + YAML + CI/CD (GitHub Actions)

## Description

This project implements a currency converter written in GNU COBOL, integrated into a CI/CD pipeline via GitHub Actions. The program reads exchange rates from a `cotacao.txt` input file and converts values from BRL to 6 different currencies.

The build process is handled through YAML workflows, leveraging GNU COBOL's internal mechanism of transpiling COBOL source code to C before compiling to a native executable — making it possible to run COBOL in modern cloud-based environments.

## How It Works

The pipeline is split into two distinct stages — compilation and execution — to avoid unnecessary recompilation on every run:

- **Compilation stage:** Compiles the COBOL source into an executable
- **Execution stage:** Runs the compiled binary with the provided input

Even with this separation, each execution requires installing GnuCOBOL and `libcob4` from scratch in the runner environment, which adds an overhead of approximately 16 to 24 seconds per run. This is an inherent limitation of ephemeral CI/CD environments rather than of the program itself.

## Supported Currencies

The program supports conversion from BRL to 6 currency types, configured via the `cotacao.txt` file.

## Technical Notes

- **Language:** GNU COBOL (transpiled to C at build time)
- **Pipeline:** GitHub Actions (YAML)
- **Input:** `cotacao.txt` (exchange rate file)
- **Dependency:** `libcob4` (installed at runtime in the CI environment)

## Key Takeaway

This project demonstrates that COBOL can be integrated into modern DevOps workflows with relatively little overhead. The main practical limitation is the absence of a persistent build environment — a Docker-based approach or a pre-built runner image would significantly reduce pipeline execution time.

---
---

# [PT-BR] Conversor de Moedas - Cobol GNU + YAML + CI/CD (Github Actions)

## Descrição

Este projeto implementa um conversor de moedas escrito em Cobol GNU, integrado a um pipeline de CI/CD via GitHub Actions. O programa lê as cotações a partir de um arquivo de entrada `cotacao.txt` e realiza a conversão de valores em BRL para 6 tipos de moeda diferentes.

O processo de build é gerenciado por workflows YAML, aproveitando o mecanismo interno do Cobol GNU de transpilar o código-fonte COBOL para C antes de compilar para um executável nativo — o que torna possível rodar COBOL em ambientes modernos baseados em nuvem.

## Funcionamento

O pipeline é dividido em duas etapas distintas — compilação e execução — para evitar recompilações desnecessárias a cada execução:

- **Etapa de compilação:** Compila o código-fonte COBOL em um executável
- **Etapa de execução:** Roda o binário compilado com a entrada fornecida

Mesmo com essa separação, cada execução exige a instalação do GnuCOBOL e do `libcob4` do zero no ambiente do runner, o que adiciona um overhead de aproximadamente 16 a 24 segundos por execução. Essa é uma limitação inerente aos ambientes de CI/CD efêmeros, e não do programa em si.

## Moedas Suportadas

O programa suporta conversão de BRL para 6 tipos de moeda, configurados via arquivo `cotacao.txt`.

## Notas Técnicas

- **Linguagem:** GNU COBOL (transpilado para C em tempo de build)
- **Pipeline:** GitHub Actions (YAML)
- **Entrada:** `cotacao.txt` (arquivo de cotações)
- **Dependência:** `libcob4` (instalada em tempo de execução no ambiente de CI)

## Conclusão

Este projeto demonstra que o COBOL pode ser integrado a workflows modernos de DevOps com relativamente pouco esforço. A principal limitação prática é a ausência de um ambiente de build persistente — uma abordagem com Docker ou uma imagem de runner pré-configurada reduziria consideravelmente o tempo de execução do pipeline.
