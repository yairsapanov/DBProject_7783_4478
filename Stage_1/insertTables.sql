-- Insert into UIClient (Updated with proper NULL values for realistic data)
INSERT INTO UIClient (client_id, name, version, release_date, client_type, domain_URL, browser_engine, app_store_URL, android_version) VALUES
(1, 'Chess Web Portal', 'v2.1.0', '2024-01-15', 'Web', 'https://chess.system.com', 'Chromium V8', NULL, NULL),
(2, 'Mobile Chess Pro', 'v4.0.2', '2024-02-20', 'Mobile', NULL, NULL, 'https://play.google.com/chess-pro', 'Android 14.0'),
(3, 'Desktop Web Admin', 'v1.0.0', '2024-03-10', 'Web', 'https://admin.chess.system.com', 'Gecko Firefox', NULL, NULL),
(4, 'Blitz Mobile App', 'v1.5.6', '2024-04-05', 'Mobile', NULL, NULL, 'https://play.google.com/blitz-chess', 'Android 14.0'),
(5, 'Analysis Dashboard', 'v3.2.1', '2024-05-12', 'Web', 'https://analysis.system.com', 'Chromium V8', NULL, NULL);

-- Insert into Engine (10 Chess Engines)
INSERT INTO Engine (engine_id, name, version, release_date) VALUES
(1, 'Stockfish', 'v16.1', '2023-06-15'),
(2, 'Komodo Dragon', 'v3.2', '2023-08-22'),
(3, 'Leela Chess Zero', 'v0.30', '2023-11-05'),
(4, 'Ethereal', 'v14.0', '2024-01-10'),
(5, 'Shredder', 'v14.5', '2024-02-18'),
(6, 'AlphaZero Cloud', 'v2.0', '2023-05-14'),
(7, 'Torch API', 'v1.2', '2023-09-01'),
(8, 'Maia Chess', 'v1.0', '2023-10-12'),
(9, 'Stoofvlees Cloud', 'v4.1', '2024-03-03'),
(10, 'Fat Fritz API', 'v2.5', '2024-04-25'),
(11, 'Stockfish Dev', 'v17.0-dev', '2024-05-01'),
(12, 'Komodo Dragon Pro', 'v3.5', '2024-04-15'),
(13, 'LCZero v0.31', 'v0.31', '2024-05-10'),
(14, 'Ethereal Experimental', 'v14.1', '2024-05-05'),
(15, 'Shredder Deep', 'v15.0', '2024-03-20'),
(16, 'AlphaZero v3.0', 'v3.0', '2024-05-15'),
(17, 'Torch API v2', 'v2.0', '2024-04-10'),
(18, 'Maia Chess v2', 'v2.0', '2024-05-01'),
(19, 'Stoofvlees Cloud v5', 'v5.0', '2024-05-12'),
(20, 'Fat Fritz API v3', 'v3.0', '2024-05-18');

-- Insert into LocalEngine (Engines 1 to 5)
INSERT INTO LocalEngine (engine_id, binary_path, threads_limit) VALUES
(1, '/usr/local/bin/stockfish_16', 32),
(2, '/usr/local/bin/komodo_dragon', 16),
(3, '/opt/engines/lc0_v030', 8),
(4, '/var/lib/engines/ethereal_14', 12),
(5, '/usr/bin/shredder_145', 4),
(11, '/usr/local/bin/stockfish_17dev', 64),
(12, '/usr/local/bin/komodo_dragon_35', 32),
(13, '/opt/engines/lc0_v031', 16),
(14, '/var/lib/engines/ethereal_141', 12),
(15, '/usr/bin/shredder_15', 8);

-- Insert into CloudEngine (Engines 6 to 10)
INSERT INTO CloudEngine (engine_id, api_url, auth_token) VALUES
(6, 'https://api.chessinfra.com/v2/alphazero', 'tok_az_9921882'),
(7, 'https://torch.chessapi.net/v1/analyze', 'tok_torch_5516112'),
(8, 'https://maia.chesscloud.org/v1/predict', 'tok_maia_3341290'),
(9, 'https://api.stoofvlees.be/v4/eval', 'tok_stoof_8829101'),
(10, 'https://fatfritz.chessbase.com/api/v2', 'tok_fritz_7716254'),
(16, 'https://api.chessinfra.com/v3/alphazero', 'tok_az_new_8821'),
(17, 'https://torch.chessapi.net/v2/analyze', 'tok_torch_new_5522'),
(18, 'https://maia.chesscloud.org/v2/predict', 'tok_maia_new_3311'),
(19, 'https://api.stoofvlees.be/v5/eval', 'tok_stoof_new_8844'),
(20, 'https://fatfritz.chessbase.com/api/v3', 'tok_fritz_new_7733');

-- Insert into HardwareNode (20 Physical Servers)
INSERT INTO HardwareNode (node_id, host_name, ram_gb, cpu_cores, datacenter_zone, ip_address, os_version) VALUES
(1, 'srv-alpha-01', 256, 64, 'US-East-Zone1', '10.0.1.11', 'Ubuntu 22.04 LTS'),
(2, 'srv-alpha-02', 256, 64, 'US-East-Zone1', '10.0.1.12', 'Ubuntu 22.04 LTS'),
(3, 'srv-beta-01', 512, 128, 'US-East-Zone2', '10.0.2.11', 'Ubuntu 22.04 LTS'),
(4, 'srv-beta-02', 512, 128, 'US-East-Zone2', '10.0.2.12', 'Ubuntu 22.04 LTS'),
(5, 'srv-gamma-01', 128, 32, 'EU-West-Zone1', '192.168.1.51', 'Debian 12 Bookworm'),
(6, 'srv-gamma-02', 128, 32, 'EU-West-Zone1', '192.168.1.52', 'Debian 12 Bookworm'),
(7, 'srv-delta-01', 1024, 256, 'EU-West-Zone2', '192.168.2.51', 'RedHat Enterprise 9'),
(8, 'srv-delta-02', 1024, 256, 'EU-West-Zone2', '192.168.2.52', 'RedHat Enterprise 9'),
(9, 'srv-epsilon-01', 64, 16, 'ASIA-Pacific-1', '172.16.5.101', 'Ubuntu 20.04 LTS'),
(10, 'srv-epsilon-02', 64, 16, 'ASIA-Pacific-1', '172.16.5.102', 'Ubuntu 20.04 LTS'),
(11, 'srv-zeta-01', 256, 64, 'ASIA-Pacific-2', '172.16.6.101', 'Ubuntu 22.04 LTS'),
(12, 'srv-zeta-02', 256, 64, 'ASIA-Pacific-2', '172.16.6.102', 'Ubuntu 22.04 LTS'),
(13, 'srv-eta-01', 512, 128, 'US-West-Zone1', '10.10.1.15', 'Ubuntu 22.04 LTS'),
(14, 'srv-eta-02', 512, 128, 'US-West-Zone1', '10.10.1.16', 'Ubuntu 22.04 LTS'),
(15, 'srv-theta-01', 128, 48, 'US-West-Zone2', '10.10.2.15', 'Debian 12 Bookworm'),
(16, 'srv-theta-02', 128, 48, 'US-West-Zone2', '10.10.2.16', 'Debian 12 Bookworm'),
(17, 'srv-iota-01', 2048, 512, 'EU-Central-1', '192.168.10.5', 'RedHat Enterprise 9'),
(18, 'srv-iota-02', 2048, 512, 'EU-Central-1', '192.168.10.6', 'RedHat Enterprise 9'),
(19, 'srv-kappa-01', 256, 64, 'EU-Central-2', '192.168.11.5', 'Ubuntu 22.04 LTS'),
(20, 'srv-kappa-02', 256, 64, 'EU-Central-2', '192.168.11.6', 'Ubuntu 22.04 LTS');

-- Insert into ServerComponent (Weak Entity - Components for the 20 servers)
INSERT INTO ServerComponent (node_id, component_sn, component_type, capacity) VALUES
(1, 'SN-RAM-A01-1', 'RAM Stick', '128GB DDR5'), (1, 'SN-CPU-A01', 'AMD EPYC CPU', '64 Cores'),
(2, 'SN-RAM-A02-1', 'RAM Stick', '128GB DDR5'), (2, 'SN-CPU-A02', 'AMD EPYC CPU', '64 Cores'),
(3, 'SN-RAM-B01-1', 'RAM Stick', '256GB DDR5'), (3, 'SN-CPU-B01', 'Intel Xeon CPU', '64 Cores'),
(4, 'SN-RAM-B02-1', 'RAM Stick', '256GB DDR5'), (4, 'SN-CPU-B02', 'Intel Xeon CPU', '64 Cores'),
(5, 'SN-RAM-G01-1', 'RAM Stick', '64GB DDR4'), (5, 'SN-CPU-G01', 'AMD EPYC CPU', '32 Cores'),
(6, 'SN-RAM-G02-1', 'RAM Stick', '64GB DDR4'), (6, 'SN-CPU-G02', 'AMD EPYC CPU', '32 Cores'),
(7, 'SN-RAM-D01-1', 'RAM Stick', '512GB DDR5'), (7, 'SN-CPU-D01', 'Intel Xeon CPU', '128 Cores'),
(8, 'SN-RAM-D02-1', 'RAM Stick', '512GB DDR5'), (8, 'SN-CPU-D02', 'Intel Xeon CPU', '128 Cores'),
(9, 'SN-RAM-E01-1', 'RAM Stick', '32GB DDR4'), (9, 'SN-CPU-E01', 'Intel Xeon CPU', '16 Cores'),
(10, 'SN-RAM-E02-1', 'RAM Stick', '32GB DDR4'), (10, 'SN-CPU-E02', 'Intel Xeon CPU', '16 Cores'),
(11, 'SN-RAM-Z01-1', 'RAM Stick', '128GB DDR5'), (11, 'SN-CPU-Z01', 'AMD EPYC CPU', '64 Cores'),
(12, 'SN-RAM-Z02-1', 'RAM Stick', '128GB DDR5'), (12, 'SN-CPU-Z02', 'AMD EPYC CPU', '64 Cores'),
(13, 'SN-RAM-ET01-1', 'RAM Stick', '256GB DDR5'), (13, 'SN-CPU-ET01', 'Intel Xeon CPU', '64 Cores'),
(14, 'SN-RAM-ET02-1', 'RAM Stick', '256GB DDR5'), (14, 'SN-CPU-ET02', 'Intel Xeon CPU', '64 Cores'),
(15, 'SN-RAM-TH01-1', 'RAM Stick', '64GB DDR4'), (15, 'SN-CPU-TH01', 'AMD EPYC CPU', '48 Cores'),
(16, 'SN-RAM-TH02-1', 'RAM Stick', '64GB DDR4'), (16, 'SN-CPU-TH02', 'AMD EPYC CPU', '48 Cores'),
(17, 'SN-RAM-I01-1', 'RAM Stick', '1024GB DDR5'), (17, 'SN-CPU-I01', 'Intel Xeon CPU', '256 Cores'),
(18, 'SN-RAM-I02-1', 'RAM Stick', '1024GB DDR5'), (18, 'SN-CPU-I02', 'Intel Xeon CPU', '256 Cores'),
(19, 'SN-RAM-K01-1', 'RAM Stick', '128GB DDR5'), (19, 'SN-CPU-K01', 'AMD EPYC CPU', '64 Cores'),
(20, 'SN-RAM-K02-1', 'RAM Stick', '128GB DDR5'), (20, 'SN-CPU-K02', 'AMD EPYC CPU', '64 Cores');

-- Insert into OpeningPosition (50 Standard Chess Openings)
INSERT INTO OpeningPosition (fen_id, fen_string, eco_code, opening_name) VALUES
(1, 'rnbqkbnr/pppppppp/8/8/4P3/8/PPPP1PPP/RNBQKBNR b KQkq e3 0 1', 'B00', 'King''s Pawn Game'),
(2, 'rnbqkbnr/pppppppp/8/8/3P4/8/PPP1PPPP/RNBQKBNR b KQkq d3 0 1', 'A40', 'Queen''s Pawn Game'),
(3, 'rnbqkbnr/pppp1ppp/8/4p3/4P3/5N2/PPPP1PPP/RNBQKB1R b KQkq - 1 2', 'C40', 'King''s Knight Opening'),
(4, 'rnbqkbnr/pppppppp/8/8/2C4/8/PP1PPPPP/RNBQKBNR b KQkq c3 0 1', 'A10', 'English Opening'),
(5, 'rnbqkbnr/pppppppp/8/8/5P2/8/PPPPP1PP/RNBQKBNR b KQkq f3 0 1', 'A02', 'Bird''s Opening'),
(6, 'r1bqkbnr/pppp1ppp/2n5/4p3/4P3/5N2/PPPP1PPP/RNBQKB1R w KQkq - 2 3', 'C50', 'Italian Game'),
(7, 'r1bqkbnr/pppp1ppp/2n5/1B2p3/4P3/5N2/PPPP1PPP/RNBQK11R b KQkq - 3 3', 'C60', 'Ruy Lopez'),
(8, 'rnbqkbnr/pp1ppppp/8/2p5/4P3/8/PPPP1PPP/RNBQKBNR w KQkq c5 0 2', 'B20', 'Sicilian Defense'),
(9, 'rnbqkbnr/pppppppp/8/8/NF3===/8/PPPPPPPP/RNBQKB1R b KQkq - 1 1', 'A04', 'Reti Opening'),
(10, 'rnbqkbnr/pppp1ppp/4p3/8/4P3/8/PPPP1PPP/RNBQKBNR w KQkq - 0 2', 'C00', 'French Defense'),
(11, 'rnbqkbnr/pp1ppppp/8/2p5/3P4/8/PPP1PPPP/RNBQKBNR w KQkq c5 0 2', 'A43', 'Old Benoni Defense'),
(12, 'rnbqkbnr/pppppppp/8/8/1P6/8/P1PPPPPP/RNBQKBNR b KQkq b4 0 1', 'A00', 'Polish Opening'),
(13, 'rnbqkbnr/pp1ppppp/2p4x/8/4P3/8/PPPP1PPP/RNBQKBNR w KQkq - 0 2', 'B12', 'Caro-Kann Defense'),
(14, 'rnbqkbnr/pppppp1p/6p1/8/4P3/8/PPPP1PPP/RNBQKBNR w KQkq - 0 2', 'B06', 'Modern Defense'),
(15, 'rnbqkbnr/pppppp1p/8/6p1/4P3/8/PPPP1PPP/RNBQKBNR w KQkq g5 0 2', 'B00', 'Borg Defense'),
(16, 'rnbqkbnr/pppppppp/8/8/P3P3/8/1PPP1PPP/RNBQKBNR b KQkq a3 0 1', 'A00', 'Anderssen Opening'),
(17, 'rnbqkbnr/pppppppp/8/8/7P/8/PPPPPPP1/RNBQKBNR b KQkq h4 0 1', 'A00', 'Grob Opening'),
(18, 'rnbqkbnr/pppppp1p/8/8/3P2p1/8/PPP1PPPP/RNBQKBNR w KQkq - 0 2', 'A40', 'Grob Countergambit'),
(19, 'rnbqkbnr/pppp1ppp/8/4p3/3P4/8/PPP1PPPP/RNBQKBNR w KQkq e5 0 2', 'A40', 'Englund Gambit'),
(20, 'rnbqkbnr/pp1pp1pp/2p5/5p2/3P4/5N2/PPP1PPPP/RNBQKB1R w KQkq - 0 3', 'A40', 'Dutch Defense'),
(21, 'rnbqkbnr/pppp1ppp/8/4p3/4P3/f4N2/PPPP1PPP/RNBQKB1R b KQkq - 1 2', 'C20', 'King''s Gambit'),
(22, 'rnbqkbnr/pppp1ppp/8/4p3/4P3/2N5/PPPP1PPP/R1BQKBNR b KQkq - 1 2', 'C23', 'Vienna Game'),
(23, 'rnbqkbnr/pppp1ppp/8/4p3/3P4/5N2/PPP1PPPP/RNBQKB1R b KQkq - 1 2', 'C44', 'Scotch Game'),
(24, 'rnbqkbnr/1ppppppp/p7/8/4P3/8/PPPP1PPP/RNBQKBNR w KQkq - 0 2', 'B00', 'St. George Defense'),
(25, 'rnbqkbnr/pppppp1p/8/8/6p1/5P2/PPPPP1PP/RNBQKBNR w KQkq - 0 2', 'A00', 'Gedult Opening'),
(26, 'rnbqkbnr/pppp1ppp/8/4p3/P7/8/1PPPPPPP/RNBQKBNR w KQkq a5 0 2', 'A00', 'Ware Opening'),
(27, 'rnbqkbnr/pppppppp/8/8/8/5N2/PPPPPPPP/RNBQKB1R b KQkq - 1 1', 'A04', 'Zukertort Opening'),
(28, 'rnbqkbnr/p1pppppp/8/1p6/4P3/8/PPPP1PPP/RNBQKBNR w KQkq b5 0 2', 'B00', 'Polish Defense'),
(29, 'rnbqkbnr/pppp1ppp/8/3Xp3/4P3/8/PPPP1PPP/RNBQKBNR w KQkq - 0 2', 'C20', 'Elephant Gambit'),
(30, 'rnbqkbnr/pppp1ppp/8/8/3pP3/8/PPP2PPP/RNBQKBNR w KQkq - 0 3', 'C20', 'Center Game'),
(31, 'rnbqkbnr/1ppppppp/8/8/p7/8/PPPPPPPP/RNBQKBNR w KQkq - 0 2', 'A00', 'Barnes Defense'),
(32, 'rnbqkbnr/pppppppp/8/8/3P4/2N5/PPP1PPPP/R1BQKBNR b KQkq - 1 1', 'A40', 'Queen''s Knight Defense'),
(33, 'rnbqkbnr/ppp1pppp/3p4/8/4P3/8/PPPP1PPP/RNBQKBNR w KQkq - 0 2', 'B00', 'Pirc Defense'),
(34, 'rnbqkbnr/pppp1ppp/8/4p3/4P3/3P4/PPPP1PPP/RNBQKBNR b KQkq - 0 2', 'C20', 'Lopez Opening'),
(35, 'rnbqkbnr/pppp1ppp/8/4p3/4P3/7N/PPPP1PPP/RNBQKB1R b KQkq - 1 2', 'C20', 'Amar Opening'),
(36, 'rnbqkbnr/pppp1ppp/8/4p3/1P6/8/P1PPPPPP/RNBQKBNR w KQkq b4 0 2', 'C20', 'Polish Gambit'),
(37, 'rnbqkbnr/pppp1ppp/8/8/4P3/8/PPPP1PPP/RNBQKBNR b KQkq - 0 1', 'C20', 'Open Game'),
(38, 'rnbqkbnr/pppppppp/8/8/4P3/8/PPPP1PPP/RNBQKBNR b KQkq e3 0 1', 'C20', 'King''s Pawn'),
(39, 'rnbqkbnr/pppp1ppp/8/4p3/4P3/5N2/PPPP1PPP/RNBQKB1R b KQkq - 1 2', 'C44', 'Open Game Mainline'),
(40, 'rnbqkbnr/pppp1ppp/8/4p3/3P4/8/PPP1PPPP/RNBQKBNR w KQkq e5 0 2', 'C20', 'Central Opening'),
(41, 'rnbqkbnr/pppp1ppp/8/4p3/4P3/2N5/PPPP1PPP/R1BQKBNR b KQkq - 1 2', 'C25', 'Vienna Game Mainline'),
(42, 'r1bqkbnr/pppp1ppp/2n5/4p3/4P3/5N2/PPPP1PPP/RNBQKB1R w KQkq - 2 3', 'C44', 'Four Knights Opening'),
(43, 'rnbqkbnr/ppp1pppp/3p4/8/3P4/8/PPP1PPPP/RNBQKBNR w KQkq - 0 2', 'A41', 'Pirc Mainline'),
(44, 'rnbqkbnr/pp1ppppp/8/2p5/3P4/8/PPP1PPPP/RNBQKBNR w KQkq c5 0 2', 'A42', 'Benoni Systems'),
(45, 'rnbqkbnr/pp1ppppp/2p5/8/3P4/8/PPP1PPPP/RNBQKBNR w KQkq - 0 2', 'A40', 'Slav Defense Setup'),
(46, 'rnbqkbnr/pppp1ppp/4p3/8/3P4/8/PPP1PPPP/RNBQKBNR w KQkq - 0 2', 'A40', 'Horwitz Defense'),
(47, 'rnbqkbnr/pppppp1p/6p1/8/3P4/8/PPP1PPPP/RNBQKBNR w KQkq - 0 2', 'A40', 'King''s Fianchetto'),
(48, 'rnbqkbnr/pp1ppppp/8/2p5/4P3/8/PPPP1PPP/RNBQKBNR w KQkq c5 0 2', 'B21', 'Sicilian Defense Main'),
(49, 'rnbqkbnr/pppp1ppp/4p3/8/4P3/8/PPPP1PPP/RNBQKBNR w KQkq - 0 2', 'C01', 'French Defense Main'),
(50, 'rnbqkbnr/pp1ppppp/2p5/8/4P3/8/PPPP1PPP/RNBQKBNR w KQkq - 0 2', 'B10', 'Caro-Kann Main');

-- Insert into Engine_UI_Support (Junction Data)
INSERT INTO Engine_UI_Support (engine_id, client_id, supported_since) VALUES
(1, 1, '2024-01-20'), (1, 2, '2024-02-25'), (2, 1, '2024-01-22'),
(2, 3, '2024-03-12'), (3, 1, '2024-02-01'), (3, 5, '2024-05-15'),
(4, 3, '2024-03-15'), (5, 2, '2024-03-01'), (6, 5, '2024-05-18'),
(7, 1, '2024-01-25'), (8, 4, '2024-04-10'), (9, 5, '2024-05-20'),
(10, 3, '2024-04-28');

-- Insert into Installed_On (LocalEngines deployed on Physical Nodes)
INSERT INTO Installed_On (engine_id, node_id) VALUES
(1, 1), (1, 2), (1, 3), (1, 4),
(2, 3), (2, 4), (2, 7), (2, 8),
(3, 7), (3, 8), (3, 17), (3, 18),
(4, 11), (4, 12), (4, 13), (4, 14),
(5, 5), (5, 6), (5, 15), (5, 16);

