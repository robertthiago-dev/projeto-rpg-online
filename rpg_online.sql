/*
    Projeto: Banco de Dados - Jogo RPG Online
    SGBD: Microsoft SQL Server
    Baseado no diagrama entidade-relacionamento fornecido na atividade do SENAI.

    Observacoes:
    - Os tipos de dados e tamanhos foram definidos tecnicamente, pois o diagrama
      informa os atributos, mas nao especifica seus tipos ou tamanhos.
    - A senha deve ser armazenada como hash gerado pela aplicacao, nunca em texto puro.
    - A tabela CLASSES_HABILIDADES implementa o relacionamento N:N entre
      CLASSES e HABILIDADES, usando chave primaria composta.
*/

CREATE DATABASE RPGOnline;
GO

USE RPGOnline;
GO

-- Tabela de usuarios: um usuario pode possuir varios personagens.
CREATE TABLE USUARIOS (
    UsuarioId INT IDENTITY(1,1) NOT NULL,
    Email NVARCHAR(254) NOT NULL,
    Senha NVARCHAR(255) NOT NULL,

    CONSTRAINT PK_USUARIOS PRIMARY KEY (UsuarioId),
    CONSTRAINT UQ_USUARIOS_Email UNIQUE (Email)
);
GO

-- Tabela de classes: uma classe pode pertencer a varios personagens.
CREATE TABLE CLASSES (
    ClasseId INT IDENTITY(1,1) NOT NULL,
    Nome NVARCHAR(100) NOT NULL,
    Descricao NVARCHAR(500) NULL,

    CONSTRAINT PK_CLASSES PRIMARY KEY (ClasseId)
);
GO

-- Tabela de habilidades.
CREATE TABLE HABILIDADES (
    HabilidadeId INT IDENTITY(1,1) NOT NULL,
    Nome NVARCHAR(100) NOT NULL,

    CONSTRAINT PK_HABILIDADES PRIMARY KEY (HabilidadeId)
);
GO

-- Tabela de personagens: cada personagem pertence a um usuario e a uma classe.
CREATE TABLE PERSONAGENS (
    PersonagemId INT IDENTITY(1,1) NOT NULL,
    NomePersonagem NVARCHAR(100) NOT NULL,
    UsuarioId INT NOT NULL,
    ClasseId INT NOT NULL,

    CONSTRAINT PK_PERSONAGENS PRIMARY KEY (PersonagemId),
    CONSTRAINT FK_PERSONAGENS_USUARIOS
        FOREIGN KEY (UsuarioId) REFERENCES USUARIOS (UsuarioId),
    CONSTRAINT FK_PERSONAGENS_CLASSES
        FOREIGN KEY (ClasseId) REFERENCES CLASSES (ClasseId)
);
GO

-- Tabela associativa: resolve o relacionamento N:N entre classes e habilidades.
CREATE TABLE CLASSES_HABILIDADES (
    ClasseId INT NOT NULL,
    HabilidadeId INT NOT NULL,

    CONSTRAINT PK_CLASSES_HABILIDADES
        PRIMARY KEY (ClasseId, HabilidadeId),
    CONSTRAINT FK_CLASSES_HABILIDADES_CLASSES
        FOREIGN KEY (ClasseId) REFERENCES CLASSES (ClasseId),
    CONSTRAINT FK_CLASSES_HABILIDADES_HABILIDADES
        FOREIGN KEY (HabilidadeId) REFERENCES HABILIDADES (HabilidadeId)
);
GO

-- Indices para auxiliar consultas pelas chaves estrangeiras.
CREATE INDEX IX_PERSONAGENS_UsuarioId
    ON PERSONAGENS (UsuarioId);
GO

CREATE INDEX IX_PERSONAGENS_ClasseId
    ON PERSONAGENS (ClasseId);
GO

CREATE INDEX IX_CLASSES_HABILIDADES_HabilidadeId
    ON CLASSES_HABILIDADES (HabilidadeId);
GO

/*
    Relacionamentos implementados conforme o diagrama:
    1. USUARIOS 1:N PERSONAGENS
    2. CLASSES 1:N PERSONAGENS
    3. CLASSES N:N HABILIDADES, por meio de CLASSES_HABILIDADES
*/
