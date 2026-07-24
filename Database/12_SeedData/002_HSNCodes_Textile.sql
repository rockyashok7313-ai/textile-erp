-- ============================================================================
-- TEXTILE ERP - SEED DATA - HSN CODES FOR TEXTILE INDUSTRY
-- ============================================================================

USE TextileERP;
GO

-- Insert Textile HSN Codes
INSERT INTO master.HSNMaster (HSNCode, HSNDescription, HSNLevel, GSTRate, CessRate, IsTextileHSN, TextileCategory)
VALUES 
-- Cotton Yarn & Fabrics
('5201', 'Cotton, not carded or combed', 4, 0, 0, 1, 'Cotton'),
('5203', 'Cotton, carded or combed', 4, 0, 0, 1, 'Cotton'),
('5204', 'Cotton sewing thread', 4, 5, 0, 1, 'Cotton'),
('5205', 'Cotton yarn (not sewing thread), containing >= 85% cotton by weight', 4, 5, 0, 1, 'Cotton'),
('5206', 'Cotton yarn (not sewing thread), containing < 85% cotton by weight', 4, 5, 0, 1, 'Cotton'),
('5207', 'Cotton yarn (not sewing thread) put up for retail sale', 4, 5, 0, 1, 'Cotton'),
('5208', 'Woven fabrics of cotton, containing >= 85% cotton by weight', 4, 5, 0, 1, 'Cotton'),
('5209', 'Woven fabrics of cotton, containing < 85% cotton by weight', 4, 5, 0, 1, 'Cotton'),
('5210', 'Woven fabrics of cotton, mixed with man-made fibres', 4, 5, 0, 1, 'Cotton'),
('5211', 'Woven fabrics of cotton, mixed with man-made fibres', 4, 5, 0, 1, 'Cotton'),
('5212', 'Other woven fabrics of cotton', 4, 5, 0, 1, 'Cotton'),

-- Synthetic Filament Yarn
('5401', 'Sewing thread of synthetic filament yarn', 4, 18, 0, 1, 'Synthetic'),
('5402', 'Synthetic filament yarn (not sewing thread)', 4, 18, 0, 1, 'Synthetic'),
('5403', 'Artificial filament yarn', 4, 18, 0, 1, 'Synthetic'),
('5404', 'Synthetic filament tow', 4, 18, 0, 1, 'Synthetic'),
('5405', 'Artificial filament tow', 4, 18, 0, 1, 'Synthetic'),
('5406', 'Synthetic filament yarn (sewing thread)', 4, 18, 0, 1, 'Synthetic'),
('5407', 'Woven fabrics of synthetic filament yarn', 4, 18, 0, 1, 'Synthetic'),
('5408', 'Woven fabrics of artificial filament yarn', 4, 18, 0, 1, 'Synthetic'),

-- Synthetic Staple Fibres
('5501', 'Synthetic filament tow', 4, 18, 0, 1, 'Synthetic'),
('5502', 'Synthetic staple fibres', 4, 18, 0, 1, 'Synthetic'),
('5503', 'Synthetic staple fibres, not carded or combed', 4, 18, 0, 1, 'Synthetic'),
('5504', 'Artificial staple fibres', 4, 18, 0, 1, 'Synthetic'),
('5505', 'Waste of man-made fibres', 4, 18, 0, 1, 'Synthetic'),
('5506', 'Synthetic staple fibres, carded or combed', 4, 18, 0, 1, 'Synthetic'),
('5507', 'Artificial staple fibres, carded or combed', 4, 18, 0, 1, 'Synthetic'),
('5508', 'Sewing thread of synthetic staple fibres', 4, 18, 0, 1, 'Synthetic'),
('5509', 'Yarn of synthetic staple fibres, containing >= 85% synthetic staple fibres', 4, 18, 0, 1, 'Synthetic'),
('5510', 'Yarn of synthetic staple fibres, containing < 85% synthetic staple fibres', 4, 18, 0, 1, 'Synthetic'),
('5511', 'Yarn of man-made staple fibres (sewing thread)', 4, 18, 0, 1, 'Synthetic'),
('5512', 'Woven fabrics of synthetic staple fibres', 4, 18, 0, 1, 'Synthetic'),
('5513', 'Woven fabrics of synthetic staple fibres, mixed with cotton', 4, 18, 0, 1, 'Synthetic'),
('5514', 'Woven fabrics of synthetic staple fibres, mixed with cotton', 4, 18, 0, 1, 'Synthetic'),
('5515', 'Other woven fabrics of synthetic staple fibres', 4, 18, 0, 1, 'Synthetic'),
('5516', 'Woven fabrics of artificial staple fibres', 4, 18, 0, 1, 'Synthetic'),

-- Knitted Fabrics
('6001', 'Pile fabrics, including "long pile" fabrics and terry fabrics', 4, 12, 0, 1, 'Knitted'),
('6002', 'Knitted or crocheted fabrics of narrow fabrics', 4, 12, 0, 1, 'Knitted'),
('6003', 'Knitted or crocheted fabrics, other than those of headings 6001 or 6002', 4, 12, 0, 1, 'Knitted'),
('6004', 'Knitted or crocheted fabrics of cotton', 4, 12, 0, 1, 'Knitted'),
('6005', 'Knitted or crocheted fabrics of synthetic fibres', 4, 12, 0, 1, 'Knitted'),
('6006', 'Other knitted or crocheted fabrics', 4, 12, 0, 1, 'Knitted'),

-- Garments
('6101', 'Men's overcoats, car-coats, cloaks, anoraks (including ski-jackets), windcheaters, wind-jackets', 4, 12, 0, 1, 'Garments'),
('6102', 'Women's overcoats, car-coats, cloaks, anoraks (including ski-jackets), windcheaters, wind-jackets', 4, 12, 0, 1, 'Garments'),
('6103', 'Men's suits, jackets, trousers, shorts', 4, 12, 0, 1, 'Garments'),
('6104', 'Women's suits, dresses, skirts, trousers, shorts', 4, 12, 0, 1, 'Garments'),
('6105', 'Men's shirts', 4, 12, 0, 1, 'Garments'),
('6106', 'Women's blouses, shirts, tunics', 4, 12, 0, 1, 'Garments'),
('6107', 'Men's underpants, briefs, nightshirts, pyjamas, dressing gowns', 4, 12, 0, 1, 'Garments'),
('6108', 'Women's slips, petticoats, nightdresses, pyjamas, dressing gowns', 4, 12, 0, 1, 'Garments'),
('6109', 'T-shirts, singlets, tank tops', 4, 5, 0, 1, 'Garments'),
('6110', 'Jerseys, pullovers, cardigans, waistcoats', 4, 12, 0, 1, 'Garments'),
('6111', 'Babies' garments and clothing accessories', 4, 5, 0, 1, 'Garments'),
('6112', 'Track suits, ski suits and swimwear', 4, 12, 0, 1, 'Garments'),
('6113', 'Garments made up of knitted or crocheted fabrics', 4, 12, 0, 1, 'Garments'),
('6114', 'Other knitted or crocheted garments', 4, 12, 0, 1, 'Garments'),
('6115', 'Stockings, socks and other hosiery', 4, 12, 0, 1, 'Garments'),
('6116', 'Gloves, mittens and mitts', 4, 12, 0, 1, 'Garments'),
('6117', 'Other made up clothing accessories, knitted or crocheted', 4, 12, 0, 1, 'Garments'),

-- Made-ups (Home Textiles)
('6301', 'Blankets and travelling rugs', 4, 12, 0, 1, 'Made-ups'),
('6302', 'Bed linen, table linen, toilet linen and kitchen linen', 4, 12, 0, 1, 'Made-ups'),
('6303', 'Curtains, drapes, interior blinds, bed valances', 4, 12, 0, 1, 'Made-ups'),
('6304', 'Other furnishing articles', 4, 12, 0, 1, 'Made-ups'),
('6305', 'Sacks and bags for packing goods', 4, 12, 0, 1, 'Made-ups'),
('6306', 'Tarpaulins, awnings and sunblinds', 4, 12, 0, 1, 'Made-ups'),
('6307', 'Other made up textile articles, worn clothing and worn textile articles', 4, 12, 0, 1, 'Made-ups'),
('6308', 'Sets consisting of woven fabric and yarn for making up into rugs, etc.', 4, 12, 0, 1, 'Made-ups'),
('6309', 'Worn clothing and other worn articles', 4, 12, 0, 1, 'Made-ups'),
('6310', 'Rags, scrap twine, rope and cables and worn out articles of twine, rope or cables', 4, 12, 0, 1, 'Made-ups'),

-- Man-made Filament Fabrics
('5408', 'Woven fabrics of artificial filament yarn', 4, 18, 0, 1, 'Synthetic'),

-- Silk
('5001', 'Silkworm gulch', 4, 0, 0, 1, 'Silk'),
('5002', 'Raw silk (not thrown)', 4, 0, 0, 1, 'Silk'),
('5003', 'Silk waste', 4, 0, 0, 1, 'Silk'),
('5004', 'Silk yarn (not sewing thread)', 4, 12, 0, 1, 'Silk'),
('5005', 'Sewing thread of silk or silk waste', 4, 12, 0, 1, 'Silk'),
('5006', 'Silk yarn put up for retail sale', 4, 12, 0, 1, 'Silk'),
('5007', 'Woven fabrics of silk or silk waste', 4, 12, 0, 1, 'Silk'),

-- Wool
('5101', 'Wool, not carded or combed', 4, 0, 0, 1, 'Wool'),
('5102', 'Fine or coarse animal hair', 4, 0, 0, 1, 'Wool'),
('5103', 'Waste of wool or fine animal hair', 4, 0, 0, 1, 'Wool'),
('5104', 'Woven fabrics of wool or fine animal hair', 4, 5, 0, 1, 'Wool'),
('5105', 'Woven fabrics of coarse animal hair', 4, 5, 0, 1, 'Wool'),
('5106', 'Yarn of carded wool', 4, 5, 0, 1, 'Wool'),
('5107', 'Yarn of combed wool', 4, 5, 0, 1, 'Wool'),
('5108', 'Yarn of fine animal hair', 4, 5, 0, 1, 'Wool'),
('5109', 'Yarn of wool or fine animal hair', 4, 5, 0, 1, 'Wool'),
('5110', 'Yarn of coarse animal hair', 4, 5, 0, 1, 'Wool'),
('5111', 'Woven fabrics of carded wool or carded fine animal hair', 4, 5, 0, 1, 'Wool'),
('5112', 'Woven fabrics of combed wool or combed fine animal hair', 4, 5, 0, 1, 'Wool'),
('5113', 'Woven fabrics of coarse animal hair', 4, 5, 0, 1, 'Wool'),

-- Denim
('52085290', 'Denim fabrics, weighing > 200 g/m2, of cotton', 8, 12, 0, 1, 'Denim'),

-- Technical Textiles
('5901', 'Wax coated fabrics', 4, 18, 0, 1, 'Technical'),
('5902', 'Tyre cord fabrics', 4, 18, 0, 1, 'Technical'),
('5903', 'Textile fabrics, impregnated, coated, covered or laminated with plastics', 4, 18, 0, 1, 'Technical'),
('5904', 'Linoleum', 4, 18, 0, 1, 'Technical'),
('5905', 'Textile wall coverings', 4, 18, 0, 1, 'Technical'),
('5906', 'Rubberised textile fabrics', 4, 18, 0, 1, 'Technical'),
('5907', 'Other impregnated, coated or covered textile fabrics', 4, 18, 0, 1, 'Technical'),
('5908', 'Textile wicks for lamps, stoves, etc.', 4, 18, 0, 1, 'Technical'),
('5909', 'Textile hoses and similar textile tubing', 4, 18, 0, 1, 'Technical'),
('5910', 'Transmission or conveyor belts or belting, of textile material', 4, 18, 0, 1, 'Technical'),
('5911', 'Textile products and articles for technical uses', 4, 18, 0, 1, 'Technical');
GO

PRINT 'HSN Codes for Textile Industry inserted successfully.';
GO
