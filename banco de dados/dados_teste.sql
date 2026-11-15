USE delivery_italiano;
INSERT INTO usuarios (id_usuario, nome, sobrenome, email, senha_hash, cpf, telefone) VALUES
(1, 'Teste', 'Importacao', 'teste.importacao@exemplo.com', 'HASH_DE_TESTE', '00000000000', '31900000000')
ON DUPLICATE KEY UPDATE nome = novo.nome;
INSERT INTO enderecos (id_endereco, id_usuario, apelido, cep, rua, numero, complemento, bairro, cidade, uf, referencia, frete) VALUES
(1, 1, 'Minha casa', '30130-000', 'Rua Exemplo', '100', NULL, 'Centro', 'Belo Horizonte', 'MG', NULL, 5.00)
ON DUPLICATE KEY UPDATE rua = novo.rua, frete = novo.frete;
