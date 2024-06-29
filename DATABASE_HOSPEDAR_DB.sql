CREATE SCHEMA hospedar_db

	-- CRIÇAO DAS TABELAS DO DB
CREATE TABLE hospedar_db.hotel (
hotel_id SERIAL PRIMARY KEY, 
nome VARCHAR(250) NOT NULL,
cidade VARCHAR(250) NOT NULL, 
uf VARCHAR(2) NOT NULL,
classificacao INT CHECK(classificacao >= 1 AND classificacao <= 5)
);

CREATE TABLE hospedar_db.quarto
(
quarto_id SERIAL PRIMARY KEY,
hotel_id INT NOT NULL,
CONSTRAINT fk_hotel_id FOREIGN KEY (hotel_id) REFERENCES
hospedar_db.hotel(hotel_id),
numero INT NOT NULL,
tipo VARCHAR(8),
preco_diaria DECIMAL NOT NULL
);

CREATE TABLE hospedar_db.cliente
(
cliente_id SERIAL PRIMARY KEY,
nome VARCHAR(250) NOT NULL,
email VARCHAR(250) NOT NULL,
telefone VARCHAR(250) NOT NULL,
cpf VARCHAR(11) NOT NULL UNIQUE
);

CREATE TABLE hospedar_db.hospedagem
(
hospedagem_id SERIAL PRIMARY KEY,
hotel_id INT NOT NULL,
CONSTRAINT fk_hotel_id FOREIGN KEY (hotel_id) REFERENCES
hospedar_db.hotel(hotel_id),
cliente_id INT NOT NULL,
CONSTRAINT fk_cliente_id FOREIGN KEY (cliente_id) REFERENCES
hospedar_db.cliente(cliente_id),
quarto_id INT NOT NULL,
CONSTRAINT fk_quarto_id FOREIGN KEY (quarto_id) REFERENCES
hospedar_db.quarto(quarto_id),
dt_checkin DATE NOT NULL,
dt_checkout DATE NOT NULL,
valor_total_hospedagem FLOAT NOT NULL,
status_hospedagem VARCHAR(10) NOT NULL
);

	-- INSERÇÃO DE DADOS DAS TABELAS
INSERT INTO hospedar_db.hotel(nome, cidade, uf, classificacao) values 
('Quality Hotel e Restaurante', 'Pocrane', 'MG', 5),
('Hotel Picada', 'Pocrane', 'MG', 4);
SELECT * FROM hospedar_db.hotel;

INSERT INTO hospedar_db.quarto (hotel_id, numero, tipo, preco_diaria) VALUES
(1, 101, 'Standard', 100.00),
(1, 102, 'Deluxe', 150.00),
(1, 103, 'Suíte', 200.00),
(1, 104, 'Standard', 110.00),
(1, 105, 'Deluxe', 160.00),
(2, 201, 'Standard', 120.00),
(2, 202, 'Deluxe', 170.00),
(2, 203, 'Suíte', 220.00),
(2, 204, 'Standard', 130.00),
(2, 205, 'Deluxe', 180.00);

INSERT INTO hospedar_db.cliente(nome, email, telefone, cpf) VALUES 
('Lorena Heringer','lorenaheringer@gmail.com', '(33)999999999', '99999999999'),
('Raphaela Heringer','raphaelaheringer@gmail.com', '(33)888888888', '88888888888'),
('Rogerio Rodrigues','rogeriorodrigues@gmail.com', '(33)777777777', '77777777777')


INSERT INTO hospedar_db.hospedagem(hotel_id, cliente_id, quarto_id, dt_checkin,dt_checkout, valor_total_hospedagem, status_hospedagem) VALUES
(1, 1, 1, '2024-06-01', '2024-06-03', 300.0, 'finalizada'),
(1, 2, 2, '2024-06-01', '2024-06-03', 450.0, 'finalizada'),
(1, 3, 3, '2024-06-01', '2024-06-03', 600.0, 'finalizada'),
(2, 1, 6, '2024-06-01', '2024-06-03', 360.0, 'finalizada'),
(2, 2, 7, '2024-06-01', '2024-06-03', 510.0, 'finalizada'),
(2, 3, 8, '2024-06-01', '2024-06-03', 660.0, 'reserva'),
(2, 1, 9, '2024-06-01', '2024-06-03', 390.0, 'reserva'),
(2, 2, 10,'2024-06-01', '2024-06-03', 540.0, 'reserva'),
(1, 3, 4, '2024-06-01', '2024-06-03', 330.0, 'reserva'),
(1, 1, 5, '2024-06-01', '2024-06-03', 480.0, 'reserva'),
(1, 2, 1, '2024-06-01', '2024-06-03', 300.0, 'hospedado'),
(1, 3, 2, '2024-06-01', '2024-06-03', 450.0, 'hospedado'),
(1, 1, 3, '2024-06-01', '2024-06-03', 600.0, 'hospedado'),
(2, 2, 6, '2024-06-01', '2024-06-03', 360.0, 'hospedado'),
(2, 3, 7, '2024-06-01', '2024-06-03', 510.0, 'hospedado'),
(2, 1, 8, '2024-06-01', '2024-06-03', 660.0, 'cancelada'),
(2, 2, 9, '2024-06-01', '2024-06-03', 390.0, 'cancelada'),
(2, 3, 10,'2024-06-01', '2024-06-03', 540.0, 'cancelada'),
(1, 1, 1, '2024-06-01', '2024-06-03', 300.0, 'cancelada'),
(1, 2, 2, '2024-06-01', '2024-06-03', 450.0, 'cancelada')

SELECT * FROM hospedar_db.hospedagem;

	-- CRIACAO DE CONSULTAS
	-- Listar todos os hotéis e seus respectivos quartos, apresentando os seguintes campos:
	--para hotel, nome e cidade; para quarto, tipo e preco_diaria;
SELECT 
    h.nome AS hotel_nome, 
    h.cidade AS hotel_cidade, 
    q.tipo AS quarto_tipo, 
    q.preco_diaria AS quarto_preco_diaria
FROM 
    hospedar_db.hotel h
JOIN 
    hospedar_db.quarto q ON h.hotel_id = q.hotel_id;

	-- Listar todos os clientes que já realizaram hospedagens 
	--(status_hosp igual á “finalizada”), e os respectivos quartos e hotéis;
SELECT 
    c.nome AS cliente_nome, 
    c.email AS cliente_email,
    c.telefone AS cliente_telefone,
    c.cpf AS cliente_cpf,
    h.nome AS hotel_nome, 
    h.cidade AS hotel_cidade, 
    q.tipo AS quarto_tipo, 
    q.preco_diaria AS quarto_preco_diaria
FROM 
    hospedar_db.cliente c
JOIN 
    hospedar_db.hospedagem hos ON c.cliente_id = hos.cliente_id
JOIN 
    hospedar_db.hotel h ON hos.hotel_id = h.hotel_id
JOIN 
    hospedar_db.quarto q ON hos.quarto_id = q.quarto_id
WHERE 
    hos.status_hospedagem = 'finalizada';


 -- Mostrar o histórico de hospedagens em ordem cronológica de um determinado cliente;
SELECT 
    hos.hospedagem_id,
    h.nome AS hotel_nome, 
    h.cidade AS hotel_cidade, 
    q.tipo AS quarto_tipo, 
    q.preco_diaria AS quarto_preco_diaria,
    hos.dt_checkin,
    hos.dt_checkout,
    hos.valor_total_hospedagem,
    hos.status_hospedagem
FROM 
    hospedar_db.hospedagem hos
JOIN 
    hospedar_db.hotel h ON hos.hotel_id = h.hotel_id
JOIN 
    hospedar_db.quarto q ON hos.quarto_id = q.quarto_id
WHERE 
    hos.cliente_id = 3
ORDER BY 
    hos.dt_checkin;

	-- Apresentar o cliente com maior número de hospedagens 
	--(não importando o tempo em que ficou hospedado);
SELECT 
    c.cliente_id,
    c.nome AS cliente_nome,
    c.email AS cliente_email,
    c.telefone AS cliente_telefone,
    c.cpf AS cliente_cpf,
    COUNT(hos.hospedagem_id) AS numero_hospedagens
FROM 
    hospedar_db.cliente c
JOIN 
    hospedar_db.hospedagem hos ON c.cliente_id = hos.cliente_id
GROUP BY 
    c.cliente_id, c.nome, c.email, c.telefone, c.cpf
ORDER BY 
    numero_hospedagens DESC
LIMIT 1;

 -- Apresentar clientes que tiveram hospedagem “cancelada”,
--os respectivos quartos e hotéis.
SELECT 
    c.nome AS cliente_nome,
    c.email AS cliente_email,
    c.telefone AS cliente_telefone,
    c.cpf AS cliente_cpf,
    h.nome AS hotel_nome, 
    h.cidade AS hotel_cidade, 
    q.tipo AS quarto_tipo, 
    q.preco_diaria AS quarto_preco_diaria,
    hos.dt_checkin,
    hos.dt_checkout
FROM 
    hospedar_db.cliente c
JOIN 
    hospedar_db.hospedagem hos ON c.cliente_id = hos.cliente_id
JOIN 
    hospedar_db.hotel h ON hos.hotel_id = h.hotel_id
JOIN 
    hospedar_db.quarto q ON hos.quarto_id = q.quarto_id
WHERE 
    hos.status_hospedagem = 'cancelada';

	-- Calcular a receita de todos os hotéis (hospedagem com status_hosp 
	-- igual a “finalizada”), ordenado de forma decrescente;
SELECT 
    h.hotel_id,
    h.nome AS hotel_nome,
    h.cidade AS hotel_cidade,
    SUM(hos.valor_total_hospedagem) AS receita_total
FROM 
    hospedar_db.hotel h
JOIN 
    hospedar_db.hospedagem hos ON h.hotel_id = hos.hotel_id
WHERE 
    hos.status_hospedagem = 'finalizada'
GROUP BY 
    h.hotel_id, h.nome, h.cidade
ORDER BY 
    receita_total DESC;

	-- Listar todos os clientes que já fizeram uma reserva em um hotel específico;
SELECT DISTINCT
    c.cliente_id,
    c.nome AS cliente_nome,
    c.email AS cliente_email,
    c.telefone AS cliente_telefone,
    c.cpf AS cliente_cpf
FROM 
    hospedar_db.cliente c
JOIN 
    hospedar_db.hospedagem hos ON c.cliente_id = hos.cliente_id
WHERE 
    hos.hotel_id = 1;

	-- Listar o quanto cada cliente que gastou em hospedagens (status_hosp igual a “finalizada”),
	--em ordem decrescente por valor gasto
SELECT 
    c.cliente_id,
    c.nome AS cliente_nome,
    c.email AS cliente_email,
    c.telefone AS cliente_telefone,
    c.cpf AS cliente_cpf,
    SUM(hos.valor_total_hospedagem) AS total_gasto
FROM 
    hospedar_db.cliente c
JOIN 
    hospedar_db.hospedagem hos ON c.cliente_id = hos.cliente_id
WHERE 
    hos.status_hospedagem = 'finalizada'
GROUP BY 
    c.cliente_id, c.nome, c.email, c.telefone, c.cpf
ORDER BY 
    total_gasto DESC;

	-- Listar todos os quartos que ainda não receberam hóspedes.
SELECT 
    q.quarto_id,
    q.tipo AS quarto_tipo,
    q.preco_diaria AS quarto_preco_diaria,
    h.nome AS hotel_nome,
    h.cidade AS hotel_cidade
FROM 
    hospedar_db.quarto q
JOIN 
    hospedar_db.hotel h ON q.hotel_id = h.hotel_id
LEFT JOIN 
    hospedar_db.hospedagem hos ON q.quarto_id = hos.quarto_id
WHERE 
    hos.hospedagem_id IS NULL;

	-- Apresentar a média de preços de diárias em todos os hotéis, por tipos de quarto.
SELECT 
    q.tipo AS tipo_quarto,
    AVG(q.preco_diaria) AS media_preco_diaria
FROM 
    hospedar_db.quarto q
GROUP BY 
    q.tipo;

	-- Criar a coluna checkin_realizado do tipo booleano na tabela Hospedagem (via código). 
	-- E atribuir verdadeiro para as Hospedagens com status_hosp 
	-- “finalizada” e “hospedado”, e como falso para Hospedagens com status_hosp 
	-- “reserva” e “cancelada”.
ALTER TABLE hospedar_db.hospedagem
ADD COLUMN checkin_realizado BOOLEAN;
UPDATE hospedar_db.hospedagem
SET checkin_realizado = 
    CASE 
        WHEN status_hospedagem IN ('finalizada', 'hospedado') THEN TRUE
        WHEN status_hospedagem IN ('reserva', 'cancelada') THEN FALSE
    END;

SELECT * FROM hospedar_db.hotel;

	-- Mudar o nome da coluna “classificacao” da tabela Hotel para “ratting
ALTER TABLE hospedar_db.hotel
RENAME COLUMN classificacao TO ratting;

	-- Criar uma procedure chamada "RegistrarCheckIn" 
	-- que aceita hospedagem_id e data_checkin como parâmetros. 
	-- A procedure deve atualizar a data de check-in na tabela "Hospedagem" e 
	-- mudar o status_hosp para "hospedado".
CREATE OR REPLACE PROCEDURE RegistrarCheckIn(
    IN p_hosp_id INT,
    IN p_data_checkin DATE
)
LANGUAGE SQL
AS $$
UPDATE hospedar_db.hospedagem
SET dt_checkin = p_data_checkin,
    status_hospedagem = 'hospedado'
WHERE hospedagem_id = p_hosp_id;
$$;

	-- Criar uma procedure chamada "CalcularTotalHospedagem" que aceita hospedagem_id 
	-- como parâmetro. A procedure deve calcular o valor total da hospedagem com base na
	-- diferença de dias entre check-in e check-out e o
	-- preço da diária do quarto reservado. O valor deve ser atualizado na coluna 
	--valor_total_hosp
CREATE OR REPLACE PROCEDURE CalcularTotalHospedagem(
    IN p_hospedagem_id INT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_dt_checkin DATE;
    v_dt_checkout DATE;
    v_preco_diaria DECIMAL(10, 2);
    v_valor_total FLOAT;
BEGIN
    -- Obter data de check-in, data de check-out e preço da diária do quarto reservado
    SELECT 
        h.dt_checkin,
        h.dt_checkout,
        q.preco_diaria
    INTO 
        v_dt_checkin,
        v_dt_checkout,
        v_preco_diaria
    FROM 
        hospedar_db.hospedagem h
    JOIN 
        hospedar_db.quarto q ON h.quarto_id = q.quarto_id
    WHERE 
        h.hospedagem_id = p_hospedagem_id;

    -- Calcular a diferença de dias entre check-in e check-out
    SELECT DATE_PART('day', v_dt_checkout - v_dt_checkin) INTO v_valor_total;

    -- Multiplicar pelo preço da diária do quarto
    v_valor_total := v_valor_total * v_preco_diaria;

    -- Atualizar o valor total da hospedagem
    UPDATE hospedar_db.hospedagem
    SET valor_total_hospedagem = v_valor_total
    WHERE hospedagem_id = p_hospedagem_id;
END $$;


	-- Criar uma procedure chamada "RegistrarCheckout" que aceita hospedagem_id e 
	-- data_checkout como parâmetros. A procedure deve atualizar a data de check-out na 
	-- tabela "Hospedagem" e mudar o status_hosp para "finalizada".
CREATE OR REPLACE PROCEDURE RegistrarCheckout(
    IN p_hospedagem_id INT,
    IN p_data_checkout DATE
)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Atualiza a data de check-out e o status da hospedagem
    UPDATE hospedar_db.hospedagem
    SET dt_checkout = p_data_checkout,
        status_hospedagem = 'finalizada'
    WHERE hospedagem_id = p_hospedagem_id;
END $$;

	-- Criar uma function chamada "TotalHospedagensHotel" que aceita hotel_id como parâmetro. 
	-- A função deve retornar o número total de hospedagens realizadas em um 
	-- determinado hotel.
CREATE OR REPLACE FUNCTION TotalHospedagensHotel(
    p_hotel_id INT
)
RETURNS INT
LANGUAGE SQL
AS $$
    SELECT COUNT(*)
    FROM hospedar_db.hospedagem h
    JOIN hospedar_db.quarto q ON h.quarto_id = q.quarto_id
    WHERE q.hotel_id = p_hotel_id;
$$;

	-- Criar uma function chamada "ValorMedioDiariasHotel" que aceita hotel_id como parâmetro. 
	-- A função deve calcular e retornar o valor médio das diárias dos quartos deste 
	-- hotel
CREATE OR REPLACE FUNCTION ValorMedioDiariasHotel(
    p_hotel_id INT
)
RETURNS DECIMAL(10, 2)
LANGUAGE SQL
AS $$
    SELECT AVG(q.preco_diaria)
    FROM hospedar_db.quarto q
    WHERE q.hotel_id = p_hotel_id;
$$;

	-- Criar uma function chamada "VerificarDisponibilidadeQuarto" que aceita quarto_id 
	-- e data como parâmetros. A função deve retornar um valor booleano indicando se o 
	-- quarto está disponível ou não para reserva na data especificada.
CREATE OR REPLACE FUNCTION VerificarDisponibilidadeQuarto(
    quarto_id INT,
    data_verificar DATE
) RETURNS BOOLEAN AS $$
DECLARE
    disponivel BOOLEAN;
BEGIN
    SELECT NOT EXISTS (
        SELECT 1
        FROM hospedar_db.hospedagem
        WHERE quarto_id = VerificarDisponibilidadeQuarto.quarto_id
          AND data_verificar BETWEEN dt_checkin AND dt_checkout
    ) INTO disponivel;

    RETURN disponivel;
END;
$$ LANGUAGE plpgsql;


	-- Criar um trigger chamado "AntesDeInserirHospedagem" que é acionado antes de uma 
	-- inserção na tabela "Hospedagem". O trigger deve verificar se o quarto está 
	-- disponível na data de check-in. Se não estiver, a inserção deve ser cancelada.

-- Criação da função para verificar a disponibilidade do quarto
CREATE OR REPLACE FUNCTION VerificarDisponibilidadeQuarto(
    quarto_id INT,
    data_verificar DATE
) RETURNS BOOLEAN AS $$
DECLARE
    disponivel BOOLEAN;
BEGIN
    SELECT NOT EXISTS (
        SELECT 1
        FROM hospedar_db.hospedagem
        WHERE quarto_id = VerificarDisponibilidadeQuarto.quarto_id
          AND data_verificar BETWEEN dt_checkin AND dt_checkout
    ) INTO disponivel;

    RETURN disponivel;
END;
$$ LANGUAGE plpgsql;

-- Criação do trigger 'ANTESDEINSERIRHOSPEDAGEM'
CREATE OR REPLACE FUNCTION ANTESDEINSERIRHOSPEDAGEM()
RETURNS TRIGGER AS $$
BEGIN
    -- Verifica se o quarto está disponível na data de check-in
    IF NOT VerificarDisponibilidadeQuarto(NEW.quarto_id, NEW.dt_checkin) THEN
        RAISE EXCEPTION 'Quarto não disponível na data de check-in. Hospedagem não pode ser inserida.';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Associação do trigger à tabela 'hospedagem'
CREATE TRIGGER antesdeinserirhospedagem_trigger
BEFORE INSERT ON hospedar_db.hospedagem
FOR EACH ROW
EXECUTE FUNCTION ANTESDEINSERIRHOSPEDAGEM();


	-- Cria um trigger chamado "AposDeletarCliente" que é acionado após a exclusão de
	-- um cliente na tabela "Cliente". O trigger deve registrar a exclusão em uma tabela
	-- de log.

-- Criação da tabela de log para exclusões de clientes
CREATE TABLE IF NOT EXISTS cliente_log (
    log_id SERIAL PRIMARY KEY,
    cliente_id INT NOT NULL,
    data_exclusao TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
-- Criação da função para o trigger
CREATE OR REPLACE FUNCTION AposDeletarCliente()
RETURNS TRIGGER AS $$
BEGIN
    -- Insere um registro na tabela de log (cliente_log) com o cliente excluído
    INSERT INTO cliente_log (cliente_id)
    VALUES (OLD.cliente_id);

    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

-- Criação do trigger para ser acionado após o DELETE na tabela cliente
CREATE TRIGGER apos_deletar_cliente_trigger
AFTER DELETE ON hospedar_db.cliente
FOR EACH ROW
EXECUTE FUNCTION AposDeletarCliente();