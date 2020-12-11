DROP TABLE IF EXISTS SF_Donation

select  dkey, 
		d.did , 
		gift_date, 
		amount, 
		ld.SF_Value 'don_type', 
		ld.Method, 
		ld.Description 'ReganomicsDonationType', 
		check_num, 
		thank_you, 
		'Received' 'Stage', --there are future donations but those are said to be typos by YAF
		a.last + ' - ' +  cast(gift_date as varchar(15)) 'DonationName',
		source
INTO SF_Donation
from Load_Donation d INNER JOIN SF_Account a
  on d.did = a.did
LEFT JOIN Lookup_DonType ld
  on d.don_type = ld.Don_Type
where source in (select source from load_projects where year(mail_date) >= 2015) and source in ('YH0998',
'RJ0198',
'RE0198',
'YH0898',
'RAN98N',
'RAN198',
'VIDEO2',
'IW0198',
'YH7A98',
'LIB698',
'NJCG04',
'RCTR04',
'RNH04E',
'RNH04C',
'RNCH04',
'GEN04E',
'GENE04',
'Y12013',
'Y1204',
'YAF19A',
'PA2N05',
'RWHD06',
'PA2C05',
'NY01',
'PA2LNA',
'R0201A',
'PA2LCA',
'LIB271',
'SAY01',
'AFCC06',
'MRT01',
'AFRHN6',
'RR1496',
'LB1199',
'WE0799',
'RTBL99',
'36465',
'MB0199',
'BLZR99',
'36434',
'CRAMAH',
'VID3YD',
'VID3YB',
'VID3YC',
'VID3YA',
'MAY03P',
'43954',
'CRAMNP',
'CNF521',
'FTF599',
'VIDEO6',
'36251',
'RR0599',
'NJCG99',
'NZM03',
'44168',
'Y11013',
'CRAMPS',
'HSPRM1',
'MR03',
'YAF7A',
'WCLC04',
'MC0104',
'DECV05',
'DECHD5',
'LSREND',
'DECLP5',
'YAF16A',
'MINJC',
'DECLD5',
'Y1001A',
'JJPIE5',
'VID10B',
'VID10A',
'FF505',
'VID9E',
'RNCH01',
'LIB301',
'GALA',
'MISC',
'RCHMIS',
'PITTS',
'NJC01',
'RR3A01',
'43862',
'43831',
'FTF101',
'RCH01E',
'HT0101',
'VID5J',
'VID5I',
'VID9D',
'VID9B',
'VID9C',
'VID9A',
'FCCUC5',
'JKS100',
'PHOTOS',
'YAF6A',
'HSPRC',
'PC2004',
'44047',
'E04Z07',
'YAF5A',
'EPN804',
'FLAG04',
'CLDR04',
'YAF4A',
'VID8E',
'VID8D',
'VID8C',
'VID8B',
'VID8A',
'MH0001',
'CX0104',
'YAF3A',
'MOH01',
'FCCTF5',
'FCCPC5',
'CRAMBX',
'FCCCC5',
'YAF25A',
'WCLC05',
'LCLUB2',
'FF0906',
'CCTF05',
'LIB273',
'SRBB06',
'IRA06',
'NJC1A',
'RUTCC6',
'GEN01E',
'GENE01',
'36861',
'YF1400',
'LEGCY1',
'RT0700',
'CI0200',
'NOV00N',
'NOV00S',
'YF1300',
'OCT00N',
'OCT00S',
'RT0600',
'36800',
'ME0BV6',
'ME0JV6',
'ME0JN6',
'MEHBN6',
'MEHJN6',
'AT0106',
'METBV6',
'LB1204',
'SBHC04',
'LIB604',
'OB001',
'RITSKY',
'CRAMCA',
'CRAMTC',
'RRMEMV',
'RRMEML',
'RRCBF1',
'RRSITE',
'E04Z05',
'VID7U',
'FF504',
'RUTTER',
'DD01',
'LIB504',
'VID7T',
'VID6F',
'44049',
'ESTATE',
'R0701A',
'CALVS6',
'BEQU06',
'GD0106',
'CALCA6',
'TAX06',
'EM06',
'R0501A',
'RRTCLB',
'CLDR06',
'GS0001',
'ME50J6',
'MAT01',
'MEHJV6',
'YAF22A',
'RT5A00',
'Y11A00',
'36739',
'Y10A00',
'LB800',
'FTF700',
'36708',
'CLDR00',
'LB0700',
'TBZ700',
'NVID8',
'NVID7',
'VIDEO8',
'CGA',
'CCUC5',
'CCCC5',
'CCPC5',
'FOX01',
'LIB205',
'YAF10A',
'SRBB05',
'RWH05',
'ROTCJJ',
'AFCCN5',
'AFRMN5',
'AFRHM5',
'AFCC05',
'RRB05',
'PC2005',
'AFPCN5',
'VID6C',
'VID6B',
'VID6E',
'VID6D',
'LIB272',
'FDR01',
'44139',
'METJV6',
'NW04',
'METJN6',
'RRJULY',
'DI06',
'CCLN06',
'YAF21A',
'R0401A',
'DVD06',
'PA3C06',
'PA3N06',
'CCHNBT',
'DN0100',
'YF0700',
'LA0100',
'HS00',
'36617',
'WC0100',
'YF0500',
'NVID6',
'NVID5',
'RR1299',
'BOG99',
'R11A99',
'HN0199',
'CH0199',
'LIB897',
'35643',
'BS0197',
'35612',
'NORTHS',
'VIDEO',
'YF8A97',
'LIB497',
'APR297',
'LIB697',
'YF7A97',
'BOONET',
'YF0697',
'HS97',
'YF5A97',
'NLPC2',
'TLPLEC',
'GP0197',
'35521',
'NTU2',
'HERTG2',
'VID6A',
'VID7S',
'RLPS04',
'MAR04B',
'Z0401A',
'WCLC06',
'AFPCN6',
'AFPC06',
'AFRH06',
'AFRHN5',
'AFRH05',
'AFPC05',
'RNH05C',
'GEN05E',
'NJCG05',
'RCTR05',
'RNCH05',
'GENE05',
'BG0104',
'44169',
'YAF8A',
'NJCJJ1',
'36404',
'PSCHOL',
'CLDR99',
'RR0899',
'TB0199',
'LIB799',
'36342',
'WE0599',
'CT0199',
'WU699',
'VIDEO7',
'DOLE1',
'LIB397',
'EBERL2',
'YF0497',
'YF0297',
'YF3A97',
'35462',
'GENE97',
'PB0103',
'CNF429',
'CRAMCR',
'CNF423',
'FD0103',
'43893',
'FF0106',
'ME0BN6',
'MEHBV6',
'METBN6',
'RR0799',
'PR0199',
'RR0699',
'LIB599',
'CNF416',
'VRE03',
'Y30103',
'SKOU03',
'CRAMFD',
'HS06',
'RCTR06',
'RRB06',
'NJCG06',
'RNH06C',
'GEN06E',
'GENE06',
'RNCH06',
'R0101A',
'YAF17A',
'CCHRB6',
'CCHNB6',
'CCLD06',
'PANA05',
'PANAH5',
'PACA05',
'PAVS05',
'PACAH5',
'LIB263',
'IRA05',
'LACDMY',
'YAF15A',
'OCTHI5',
'44077',
'CNF102',
'CNF101',
'CNF930',
'PC2003',
'EMGY03',
'44046',
'Y70103',
'JC0103',
'CLDR03',
'LIB703',
'JUN03B',
'43985',
'BARL03',
'CW0103',
'VID3HA',
'VID3MA',
'VID3HB',
'43864',
'CNF311',
'NJC502',
'LEGCY2',
'TBZ502',
'RL0102',
'HS02',
'GG0102',
'VDEO11',
'43892',
'RCTR02',
'RAWHDE',
'VDEO10',
'CLB100',
'RROH',
'NJCG02',
'RNCH02',
'CNF313',
'LIB203',
'RWHD03',
'GEN02E',
'GENE02',
'43832',
'YF2A02',
'YF1A02',
'44136',
'DC0101',
'CR0101',
'LB1001',
'44105',
'MN0101',
'TBZ901',
'RCTR01',
'RRB03',
'CRAMBS',
'CRAMAC',
'GEN03E',
'RCTR03',
'NJCG03',
'RNCH03',
'GENE03',
'43833',
'YF1A03',
'NJC122',
'MERP02',
'44137',
'BOR02P',
'44106',
'PH02P',
'HRT02P',
'YF10A',
'WCLC02',
'CCPNB6',
'YAF20A',
'CCPC06',
'CCPNN6',
'CCRB06',
'APR298',
'YH0698',
'35886',
'LIB498',
'YH0598',
'HS98',
'FEB98N',
'FF0198',
'SBCNF2',
'44075',
'CRM85A',
'CRAM85',
'YF9A02',
'HNBKRR',
'BOST02',
'NJC802',
'PC2002',
'44076',
'YF8A02',
'44045',
'CLDR02',
'MEYER1',
'44014',
'SBCNF3',
'R0301A',
'NJCH06',
'NJCL06',
'AFRHM6',
'PA2HCA',
'PA2HNA',
'R11A94',
'AFCCN6',
'GFHD01',
'AUG01B',
'AUG01A',
'RR9A01',
'44044',
'NJCG01',
'LIB701',
'NJC02',
'43984',
'VID7Q',
'VID7R',
'VID7X',
'VID7O',
'VID7P',
'VID7H',
'VID7L',
'VID7N',
'CLDR01',
'43983',
'RR7A01',
'HS01',
'DR0201',
'MAR012',
'RR6A01',
'LT0101',
'43952',
'CI0301',
'RR5A01',
'TBZ401',
'43891',
'RT0200',
'36526',
'YFA100',
'HS99',
'CC0199',
'DR0199',
'WE3A99',
'VID7J',
'VID7E',
'VID7F',
'VID7W',
'VID7D',
'VID7K',
'VID7C',
'VID7I',
'VID7V',
'RT0100',
'NVID4',
'NVID3',
'NVID2',
'NVID1',
'CI0700',
'GEN00E',
'RNCH00',
'GENE00',
'YF1A00',
'BB0199',
'36495',
'WE0899',
'RR1399',
'JA0199',
'VIDEO5',
'RA0199',
'VIDEO4',
'WE0199',
'36161',
'RRWEB',
'RR0199',
'GEN99E',
'GENE99',
'YH1398',
'36100',
'VIDEO3',
'VID7M',
'VID7G',
'VID7B',
'VID7A',
'NJC404',
'TL0104',
'MAR04A',
'CO0104',
'43894',
'MH01',
'RWH04',
'43865',
'CRAMAP',
'E04Z01',
'RRB04',
'43834',
'LB1198',
'RANRCC',
'YH1298',
'RAN2N0',
'RAN98E',
'RANLPC',
'RAN98H',
'YH1198',
'RAN98L',
'RANCH',
'36039',
'YH1098',
'LIB898',
'RAN298',
'36008',
'AZPL11',
'STEIN3',
'EF0601',
'AZPC11',
'AZCC11',
'STEIN1',
'STEIN2',
'YAF86A',
'AFLD12',
'AFDL12',
'AFDH12',
'AFCC12',
'NJC25A',
'AFPC12',
'AFPL12',
'G0101A',
'HS2012',
'IRA12',
'ENDOW12',
'FRW27T',
'FRW27A',
'FRW33A',
'FRW33T',
'FRW21T',
'FRW35T',
'FRW35A',
'FRW23T',
'FRW23A',
'FRW25A',
'FRW25T',
'DJB001',
'FRW21A',
'YAF120',
'AZLPD4',
'AZPCZ4',
'AZPCX4',
'AZPCT4',
'AZCCX4',
'CLDR07',
'CRAMA7',
'NCSC7',
'TXBOOK',
'PCBOOK',
'ALUM1',
'DVDB',
'DVDC',
'DVDA',
'DVDD',
'HS07',
'CAL26T',
'CAL33T',
'CAL28T',
'CAL30T',
'CAL31T',
'CAL23T',
'CAL21T',
'YAF105',
'CAL04A',
'STEIN4',
'BEQU11',
'CRAMEE',
'CLDR11',
'LIB321',
'YAF77A',
'NJC19A',
'BSL01',
'NCSC77',
'NCSC55',
'NCSCWW',
'NCSCSS',
'EF0401',
'YAF76A',
'NCSC66',
'NCSCY4',
'ISU01',
'AFLL11',
'AFDL11',
'AFDH11',
'NOV111',
'RRF001',
'NJCALL',
'NOV511',
'YAF83A',
'NOV331',
'NOV441',
'NOV611',
'NOV711',
'NOV911',
'NOVT11',
'NOV311',
'NOV811',
'NOV211',
'NOV551',
'NOV411',
'EMER10',
'NCSFW2',
'AZPL12',
'NOV609',
'NOV709',
'NOV809',
'NOV209',
'NOV239',
'NOV409',
'NOV119',
'NOV129',
'NOV909',
'NOVT09',
'NOV309',
'PC2009',
'NOV509',
'BOOK02',
'BOOK01',
'RC0001',
'YAF59A',
'NJCH5A',
'A0901A',
'CAL02A',
'CAL03A',
'CAL18A',
'CAL22A',
'CAL24A',
'CAL29A',
'CAL25A',
'CAL33A',
'CAL30A',
'CAL20A',
'CAL23A',
'CAL21A',
'CAL31A',
'H0701A',
'AZCT13',
'AZCCC3',
'AZPL13',
'AZCL13',
'AZPC13',
'AZCC13',
'BHP01',
'AFCL11',
'KCL01',
'AFPL11',
'YAF75A',
'RWHD11',
'AFLD11',
'EF0201A',
'AFPC11',
'AFCC11',
'NJC18A',
'TF0001',
'YAF74A',
'RGN101',
'CRAMEA',
'IRA11',
'RGN100',
'EF0101',
'WCLC11',
'NJDAY11',
'AZPC12',
'AZCL12',
'AZCC12',
'TCON14',
'RRHS12',
'TCON13',
'TCON11',
'BLDGRC',
'TCON12',
'NJC37A',
'NDC06A',
'NDC02A',
'NDC09A',
'NDC04A',
'NDC18A',
'NDC08A',
'NDC16A',
'NDC11A',
'NDC14A',
'NDC10A',
'IRA09',
'911',
'AUGS09',
'44052',
'A0801A',
'FENDOW',
'FBI',
'FAKE',
'F11',
'CHAIR3',
'YAF58A',
'CHAIR4',
'CHAIR2',
'BEQU09',
'TAX09',
'AZCL09',
'AZCC09',
'AZPCL9',
'AZPC9',
'A0701A',
'NJC35A',
'YAF103',
'NCS227',
'NCS226',
'CRAMFJ',
'NCS223',
'FINK',
'CRAMPM',
'NCS225',
'NJC34A',
'YAF102',
'NCS221',
'NCS222',
'43923',
'C1422A',
'C1414A',
'C1407A',
'C1420A',
'C1415A',
'C1419A',
'EXHIB8',
'YAF46A',
'JULY8X',
'NJC28',
'NJC18',
'NJC08',
'STEP18',
'STEP08',
'F0601A',
'SWAP8',
'TAX08',
'32690',
'32325',
'31959',
'31594',
'30864',
'31229',
'29768',
'30133',
'NDC12A',
'NDC13A',
'NDC15A',
'NDC20A',
'NDC03A',
'NDC07A',
'NDC01A',
'NDC19A',
'NDC05A',
'NDC22A',
'NDC17A',
'NDC29A',
'NDC24A',
'NDC31A',
'NDC28A',
'NDC26A',
'NDC33A',
'NDC32A',
'NDC30A',
'NDC34A',
'NDC27A',
'MER01',
'44021',
'CLDR09',
'14427',
'44041',
'44031',
'RELIB9',
'A0601A',
'UPLIB9',
'NCSCRR',
'YAF57A',
'NCS224',
'RRHS13',
'CLDR13',
'H0401A',
'QP0001',
'YAF101A',
'BOS001',
'AFDH13',
'43922',
'C1424A',
'C1429A',
'C1405A',
'C1417A',
'C1401A',
'C1403A',
'C1433A',
'C1431A',
'C1426A',
'C1430A',
'C1427A',
'C1428A',
'C1435A',
'C1432A',
'NJC40A',
'C1434A',
'C1416A',
'C1421A',
'C1425A',
'C1423A',
'TAX14',
'OCTL05',
'PC1105',
'NJC5A',
'Y0701A',
'44048',
'AUGH05',
'ROTC01',
'CLNRVT',
'CLDR05',
'CLNRCA',
'CALEN6',
'LCLUB1',
'Y0601A',
'AN01',
'44017',
'CLNR05',
'NIK01',
'CLDRB5',
'LIB262',
'MLB01',
'YAF69A',
'BEQU10',
'Y0801A',
'44025',
'44024',
'44023',
'YAF68A',
'44022',
'YAF67A',
'TAX10',
'AZCL10',
'AZCS10',
'AZPL10',
'AZCT10',
'NJC13A',
'AZPC10',
'YI0135',
'YAF66A',
'PBS01A',
'NDC20B',
'NDC26B',
'NDC07B',
'NDC31B',
'NDC03B',
'NDC33B',
'NDC18B',
'NDC35B',
'NDC28B',
'NDC30B',
'NDC32B',
'NDC34B',
'NDC36B',
'NDC29B',
'NDC25B',
'NDC27B',
'NDC23B',
'NDC16B',
'NJC42A',
'YAF124',
'VID05T',
'YAF100A',
'SUR001',
'AFCL13',
'RRCC13',
'LIB341',
'AFPL13',
'YAF99A',
'NJC32A',
'H0201A',
'RWHD13',
'YAF98A',
'AFLD13',
'AFPC13',
'IRA13',
'AFDL13',
'AFCT13',
'AFCCC3',
'AFSTMP',
'AFNSTP',
'AFCC13',
'Y0501A',
'VID9L',
'LPSD05',
'VID9K',
'LPLD05',
'YAF12A',
'LIB505',
'MMRH05',
'MMC05',
'MMPC05',
'Y0401A',
'MMCR05',
'VID9G',
'VID9H',
'VID9M',
'VID9I',
'VID9J',
'VID9F',
'GF0001',
'RRSFP10',
'AFS2010',
'NCSCR3',
'NJC12A',
'NCSCF1',
'KAGNK',
'ZINN14',
'KAGN50',
'KAGN10',
'ZINN16',
'PA0001',
'ZINN12',
'CLDR10',
'RWHD10',
'LIB311',
'ZINN10',
'NCSC12',
'EY0401',
'NCSC11',
'YAF65A',
'CFE35T',
'CFE32R',
'CFE32T',
'CFE34R',
'CFE34T',
'YAF123',
'J0901A',
'TFCGAL',
'NJC41A',
'YAF122',
'C1418A',
'C1402A',
'C1404A',
'C1409A',
'C1410A',
'C1406A',
'C1413A',
'C1411A',
'C1412A',
'C1408A',
'NOV552',
'H0101A',
'EFT13',
'NJDAY13',
'HSP13G',
'ENDOW13',
'NJCH13',
'NJCG13',
'RNH13C',
'RCTR13',
'RNCH13',
'GENE13',
'GEN13E',
'NOV112',
'NOV712',
'NOV512',
'YAF97A',
'NOV332',
'NOV612',
'NOV912',
'CRAMCD',
'NJC3A',
'30498',
'CLDR08',
'ASHLY4',
'YAF44A',
'YAF43A',
'ASHLY9',
'GRC01A',
'LIB291',
'ASHLY1',
'ASHL38',
'ASHLEY',
'ASHL28',
'ASHLY8',
'F0401A',
'AZCC08',
'AZCL08',
'AZPL08',
'NCSC1B',
'NCSCG1',
'NCSC10',
'NJC10A',
'DVD10',
'HANA12',
'STEP10',
'HANA10',
'HANA10T',
'MRN01A',
'NDC23A',
'NDC21A',
'NDC25A',
'NDC35A',
'NDC36A',
'YAF109',
'CFE04A',
'CFE02A',
'CFE18A',
'CFE06A',
'NCSCT8',
'NG0001',
'F0201A',
'ROTCFL',
'ROTCCC',
'SADA08',
'ROTCTA',
'ROTC08',
'RWHD08',
'AFLL08',
'F0101A',
'AFPML8',
'AFCML8',
'MIKE08',
'AFPL08',
'AFCL08',
'AFLD08',
'AFDH08',
'AFCC08',
'NOVT12',
'NCSC14',
'CAL34A',
'CAL26A',
'NCS12A',
'NCS14A',
'NCS17A',
'NCS09A',
'NCS02A',
'NCS04A',
'NCS06A',
'NCS10A',
'NCS08A',
'NCS01A',
'NCS07A',
'NCS03A',
'NCS05A',
'J0401A',
'NCS22A',
'NCS29A',
'NCS29B',
'AZPLM8',
'AZPC08',
'NCSCF8',
'NCSCL8',
'NEWTEV',
'NCSC48',
'F0301A',
'NCSC38',
'YAF41A',
'NCSC28',
'WSG08',
'NCSC08',
'NCSC18',
'NCSCG8',
'ENDOW11',
'RCTR11',
'HSP11G',
'NJCG11',
'RNH11C',
'GEN11E',
'CFE10A',
'CFE16A',
'CFE08A',
'CFE15A',
'CFE14A',
'CFE12A',
'CFE07A',
'CFE11A',
'CAL27A',
'CAL28A',
'LIB352',
'J0701A',
'YAF121',
'AZLPW4',
'RRHS14',
'NCSG14',
'J0601A',
'FRW01A',
'FRW01T',
'FRW18A',
'AFPC08',
'ENDOW8',
'WCLC08',
'RCTR08',
'RNH08C',
'RNCH08',
'NJCG08',
'GEN08E',
'GENE08',
'USSRGN',
'PHOTO',
'Y1101A',
'LIB283',
'IBLS',
'44172',
'44182',
'44192',
'Y10018',
'NOVN07',
'YAF36A',
'HS2010',
'HANA11',
'YAF64A',
'UCSB10',
'HANA10N',
'AFLL10',
'MMB01',
'Y0201A',
'AFLD10',
'YAF63A',
'NJC8A',
'AFCL10',
'AFCS10',
'AFCT10',
'HG0001',
'AFPL10',
'AFPC10',
'AFDH10',
'A1301A',
'RNCH11',
'GENE11',
'NJC17A',
'REGN100',
'ACRE100',
'YAF72A',
'NJC16A',
'PE10LD',
'PE2010',
'GFT01',
'PC2010',
'NJCCC',
'EMER09',
'NJCBB',
'NJCAA',
'EMER11',
'YAF71A',
'PC2011',
'WCLCHD',
'NJC23A',
'TFC1M1',
'TFC3M2',
'CRM48L',
'J0301A',
'ATTK14',
'CRE006',
'BEQB14',
'BEQU14',
'ALS001',
'J0201A',
'AFDHT4',
'AFPCT4',
'YAF114',
'LIB351',
'AFLPD4',
'AFLPG4',
'AFLPW4',
'RWHD14',
'TFCM14',
'GBS14I',
'NOV107',
'NOV407',
'NOV117',
'NOV907',
'NOV307',
'NOV207',
'NOV807',
'NOV707',
'NOV507',
'NOV127',
'NOV607',
'SPL22N',
'BEQU12',
'SPL50',
'SPL11N',
'G0701A',
'SPL22V',
'SPL11V',
'CRAMET',
'CFC',
'ENDOW10',
'NJDAY10',
'NJC10H',
'NJCG10',
'HSP10G',
'RCTR10',
'RNH10C',
'RNCH10',
'GENE10',
'GEN10E',
'RTBL2010',
'RCRTBL',
'YAF62A',
'44184',
'44174',
'GIL01',
'CRAM09',
'HGLNJC',
'A1201A',
'MTT01',
'WCLC1T',
'NNJC13',
'WCLCG',
'EF1101',
'WCLCLD',
'NNJC12',
'WCLC1L',
'NNJC11',
'LEVTN',
'LIB322',
'WCLC10',
'RRHS11',
'WCLC10P',
'DF0001',
'EY1001',
'CRAMEK',
'CRAMDV',
'FREY02',
'LEVLD',
'CRAMEJ',
'CREN01',
'CRE001',
'AFLLZ4',
'AFDHX4',
'J0101A',
'YAF113',
'NJC38A',
'AFLLX4',
'AFCCZ4',
'CRM225',
'AFCCZ5',
'AFPCZ4',
'AFCCX4',
'AFPCX4',
'HSP14G',
'CEFE14',
'ACRE',
'EFT14',
'TFCG14',
'IRA14',
'YAF90A',
'SPL100',
'NCS127',
'CLDR12',
'NCS126',
'NCS124',
'NCS123',
'NCS125',
'HC0001',
'MCY001',
'NJC27A',
'NCS121',
'G0401A',
'SPP001',
'NCS122',
'STEP13',
'STEP12',
'RGNBOOK',
'WCLC12',
'AZDL12',
'MAKRIS',
'SURVEY',
'JOE01',
'YAF61A',
'JIM01',
'JD0109',
'LIB302',
'NOV109',
'YAF60A',
'YF0197',
'NCS24A',
'NCS26A',
'NCS31A',
'NCS28A',
'NCS30B',
'NCS30A',
'NCS33A',
'NCS27A',
'NCS28B',
'NCS32A',
'NCS23A',
'HS09',
'YAF56A',
'PM101',
'PM100',
'RRHS10',
'PLEDGE',
'NCSCG9',
'YAF55A',
'NCSC29',
'CTCONF',
'CS01',
'CRISIS',
'COX',
'COMEDY',
'COLUMB',
'CJ0196',
'SR0196',
'YC0001',
'NCSC19',
'NCSC9',
'YAF54A',
'RNH14C',
'NJCG14',
'RCTR14',
'RNCH14',
'GENE14',
'GEN14E',
'YAF112',
'H1201A',
'YAF111',
'H1101A',
'FRW04T',
'FRW18T',
'FRW16T',
'FRW16A',
'FRW09T',
'FRW09A',
'FRW02T',
'FRW04A',
'FRW02A',
'FRW20T',
'YAF88A',
'NJC26A',
'LIB331',
'MM122',
'MM121',
'MM124',
'MM123',
'MIK127',
'MIK126',
'MIK122',
'MIK123',
'MIK125',
'MIK124',
'MIK121',
'MIKE12',
'GR0001',
'NDL001',
'YAF87A',
'RWHD12',
'NCS25A',
'CLDR14',
'NCS21A',
'NCS22B',
'NCS24B',
'NCS27B',
'NCS26B',
'NCS25B',
'NCS21B',
'NCS23B',
'YAF117',
'TFCGFC',
'TFC2S2',
'TFC2S1',
'NJC39A',
'TFC1JB',
'TFCP14',
'TFC1S1',
'YAF116',
'TFC2M3',
'YAF50',
'LB301',
'LRR019',
'MIKE09',
'WCLC09',
'RWHD09',
'AFLDL9',
'NEWTEV2',
'ALEX99',
'EA0109',
'AFLD09',
'AFCL09',
'AFCC09',
'AFPC9',
'AFPCL9',
'AFDH09',
'OMP0109',
'ENDOW9',
'RNCH09',
'YAF31A',
'MARMRF',
'DI07',
'CCLD7',
'PB0107',
'CCSD7',
'CRAMRR',
'CCHD7',
'MARMRS',
'MARMRL',
'NJCSL7',
'NJCL07',
'MARMR7',
'GMT01A',
'FY0107',
'AFLML7',
'CSH01A',
'RWHD07',
'AFLL07',
'AFLL12',
'G0201A',
'AFCL12',
'CAL35A',
'CAL06A',
'CAL16A',
'CAL10A',
'CAL08A',
'CAL09A',
'CAL15A',
'CAL13A',
'CAL14A',
'CAL12A',
'CAL07A',
'CAL19A',
'CAL11A',
'CAL01A',
'CAL17A',
'CAL05A',
'CAL32A',
'TFC3S2',
'TFC3S1',
'AZLPG4',
'AZCCZ4',
'USRR',
'YAF118',
'J0501A',
'ATK100',
'PC2014',
'NCS18A',
'NCS13A',
'NCS11A',
'NCS16A',
'NCS20A',
'NCS15A',
'NCS19A',
'NDC13B',
'NDC21B',
'NDC15B',
'NDC01B',
'HSP09G',
'RNH09C',
'GEN09E',
'RCTR09',
'NJCG09',
'GENE09',
'ALEX18',
'ALEX28',
'ALEXL8',
'ALEX08',
'LEV13',
'FRET02',
'LEV10',
'FREJ01',
'LEV12',
'FREE01',
'LEV11',
'EF1001',
'AUG102',
'NJC22A',
'AFPML7',
'AFCML7',
'AFPL07',
'AFCL07',
'AFDH07',
'MN2007',
'LIB281',
'SDL207',
'AFLD07',
'AFCC07',
'AFPC07',
'NJCG07',
'RNH07C',
'RNCH07',
'GEN07E',
'GENE07',
'ENDOW7',
'WCLC07',
'Y0101A',
'CFE03A',
'CFE29A',
'CFE27A',
'CFE32A',
'CFE26A',
'CFE35A',
'PC2013',
'CFE09A',
'CFE13A',
'CFE20A',
'CFE01A',
'CFE05A',
'CFE17A',
'CFE22A',
'CFE24A',
'CFE33A',
'CFE31A',
'CFE30A',
'CFE28A',
'CFE34A',
'NOV812',
'NOV412',
'NOV312',
'G1301A',
'RRG001',
'EOY12',
'FREENT',
'NOV212',
'PE2312',
'PE2112',
'PE2012',
'YAF96A',
'LIB333',
'PC2012',
'FILM10',
'FILM13',
'FILM11',
'FILM09',
'FILM12',
'F1101A',
'DEC28X',
'DECP28',
'DECP8',
'FF2008',
'DECP18',
'44193',
'44183',
'44173',
'PE08E',
'BZP01',
'LIB292',
'CRAMXS',
'MAL01A',
'PE2008',
'NOV708',
'NOV608',
'NOV808',
'NOV508',
'MS0001',
'RCTR07',
'SC0001',
'DECL06',
'44171',
'44141',
'NOVR06',
'RUTBEF',
'RU1000',
'R0901A',
'RU2500',
'RUT100',
'PC2006',
'FRW20A',
'FRW14T',
'FRW14A',
'FRW19T',
'FRW19A',
'FRW06T',
'FRW06A',
'CFE21A',
'CFE25A',
'CFE23A',
'MYTHRB',
'CFE19A',
'YAF108',
'H0901A',
'YC0114',
'LIB342',
'CRAMFM',
'YAF106',
'BEQB13',
'BEQU13',
'CAL36T',
'CAL34T',
'CAL22T',
'CAL29T',
'CAL27T',
'CAL24T',
'CAL25T',
'GB0001',
'FILM14',
'PVL001',
'JUL134',
'JULV33',
'JULV34',
'JUL133',
'JULV32',
'G0901A',
'CRAMEZ',
'CRAMEX',
'JUL132',
'YAF94A',
'TAN001',
'JUL131',
'LIB332',
'MRJ001',
'NJC28A',
'NCSFL3',
'YAF91A',
'NOV234',
'NOV108',
'NOV308',
'NOV408',
'NOV208',
'IRA08',
'NOV118',
'NOV128',
'NOV908',
'NOVT08',
'PC2008',
'H01PC',
'H01P6',
'H01P5',
'AUGS8',
'YAF47A',
'44051',
'F0701A',
'ERL01H',
'FRW12T',
'FRW12A',
'FRW08T',
'FRW08A',
'FRW15T',
'FRW15A',
'FRW11A',
'FRW17T',
'FRW11T',
'FRW17A',
'FRW10A',
'FRW10T',
'FRW13T',
'FRW13A',
'FRW22A',
'FRW22T',
'FRW29A',
'FRW29T',
'FRW07T',
'NOVC07',
'NOVT07',
'Y0901',
'NFD01',
'GWUL07',
'GWU07',
'PC2007',
'FWALL7',
'CRAMSP',
'NEWTG7',
'NEWTST',
'IRA07',
'NEWTBR',
'BTSG07',
'BTSL07',
'BEQU07',
'BTSH07',
'NJSL7',
'NJCL7',
'NJC07',
'NJDAY12',
'FGFILM',
'NJCG12',
'HSP12G',
'RNH12C',
'RCTR12',
'RNCH12',
'GENE12',
'GEN12E',
'RTBL2011',
'YAF85A',
'DEC120',
'LIBRRI',
'DEC121',
'ZHAO11',
'NJC24A',
'SCLSHIP',
'YAF84A',
'F1301A',
'F1201A',
'JML001',
'CRAMWC',
'EUHI83',
'YAF45A',
'EXHI83',
'EXHI8D',
'EUHI8D',
'EUHI8C',
'EXHI8C',
'EUHI82',
'EXHI82',
'EUHIB8',
'EY0901',
'JUL124',
'CRAMDU',
'YAF81A',
'AUG101',
'JUL121',
'44053',
'EF0901',
'JUL123',
'FRW07A',
'FRW24T',
'FRW24A',
'FRW03A',
'FRW03T',
'FRW05A',
'FRW05T',
'FRW34T',
'FRW34A',
'FRW26T',
'FRW26A',
'FRW32A',
'FRW32T',
'FRW28T',
'FRW28A',
'FRW31T',
'FRW31A',
'FRW30T',
'FRW30A',
'Y0607A',
'JULYBR',
'JULYST',
'YAF33A',
'JULYCT',
'JULYRH',
'JULYCP',
'JULYPC',
'JULYCA',
'JULYTV',
'JULYRV',
'JS0001',
'LIB282',
'TAX07',
'NEWT27',
'NEWT07',
'DVDE',
'NEWT17',
'CCLL7',
'YAF73A',
'44175',
'44176',
'REA01',
'NOV444',
'NOV333',
'NOV910',
'NOVT10',
'NOV555',
'Y1201A',
'NOV610',
'NOV710',
'NOV810',
'NOV510',
'NOV310',
'NOV210',
'NOV410',
'NOV110',
'LIB312',
'JUL122',
'CRAMEI',
'EF0801',
'TAX11',
'NJC21A',
'SP115',
'TTA01',
'YAF80A',
'BTPLAN',
'SP114',
'SP113',
'NJC20A',
'EMR01',
'NCSFL2',
'NCSFL1',
'NCSFW1',
'CRAMEF',
'AZCL11',
'NF0001',
'THORN',
'JANHD',
'GENE90',
'TURN',
'BKMARK',
'LIBERT',
'GENE82',
'GENE80',
'GENE81',
'FEMERG',
'STAMP',
'RIGHTS',
'DARTMO',
'GENE79',
'Y11A95',
'34943',
'34912',
'YF9A95',
'34881',
'34851',
'RW0195',
'YF0895',
'YF0795',
'GR01',
'APR295',
'34820',
'AD01',
'MATCH',
'34790',
'FY01',
'YF0495',
'34759',
'SCHOOL',
'HARV',
'DART',
'BEWALL',
'GENE89',
'HDE',
'HDD',
'HDB',
'HDC',
'SHD',
'HDA',
'LDB',
'GENER',
'LDC',
'LDA',
'GENE88',
'GENE87',
'GENE86',
'GENE85',
'GENE84',
'GENE83',
'SHERMA',
'35431',
'LUCE',
'LIBDEC',
'RH0196',
'NORTH1',
'RR1696',
'35370',
'35309',
'RR1296',
'R11A96',
'35278',
'SALVBK',
'35247',
'RR0996',
'R10A96',
'NLPC',
'LIB796',
'RR0896',
'ACU',
'RR7296',
'APR296',
'RP01',
'NTU',
'HERTGE',
'CE0196',
'EBERLE',
'35186',
'RR0696',
'RR0596',
'FP01',
'35156',
'PEARSN',
'DFMASS',
'RR3196',
'35034',
'YF1595',
'UN01',
'35004',
'YF1395',
'34973',
'35827',
'DCONF',
'LIB298',
'YH0398',
'GHLECT',
'35065',
'RR0196',
'FL01',
'STOCKS',
'RR2196',
'35096',
'GENE96',
'DP0196',
'34090',
'APR293',
'IM',
'GENBRO',
'34060',
'GEN98E',
'GENE98',
'YH1A98',
'AS0197',
'35765',
'MP0197',
'WABASH',
'35674',
'Y11A97',
'YF1097',
'UF0197',
'PS',
'YF0695',
'UMASS',
'NW',
'YF05',
'YF04',
'WU01',
'SP08',
'34029',
'RW09',
'HM',
'34001',
'33970',
'GENE93',
'33604',
'NORTHL',
'34366',
'GENE94',
'34335',
'CERT94',
'OVERYR',
'34304',
'YF14',
'OCTH93',
'34274',
'FLNORT',
'34243',
'Y12A',
'33939',
'YF',
'VALECT',
'FLCONF',
'33909',
'R11A',
'R12A',
'YS',
'Y14A97',
'LB1297',
'LB1197',
'35735',
'PERSN2',
'YF1297',
'YF1193',
'34213',
'RL01',
'AT',
'Y10A',
'34121',
'34151',
'YF09',
'RVIDEO',
'33878',
'BLDG',
'RR10',
'RR09',
'33817',
'33848',
'RACE',
'DEC',
'NOV',
'RRPOST',
'SEPT',
'GOLD',
'SSF1',
'QUAYLE',
'MAGNET',
'MAY',
'SS12',
'REPORT',
'SPEAKR',
'NRIGHT',
'FEBHD',
'RNH19C',
'RNCH19',
'RCTR19',
'PC2019',
'NJCG19',
'HSP19G',
'GENE19',
'YAF184',
'FSPEECH',
'JAN19TS',
'EOY185',
'HNA001',
'YAF182',
'EOY184',
'EOY183',
'EOY182',
'NOV18K',
'EOY181',
'NOV18G',
'NOV18D',
'YAF130',
'NCRNC',
'NJC45A',
'K0301A',
'NCNNB',
'NCRNB',
'YAF129',
'AFDHX5',
'AFDHT5',
'MRK001',
'ATK001',
'NOVR93',
'NOVR92',
'MATI01',
'NOVR91',
'CAMP05',
'CAMP03',
'LIB362',
'YAL001',
'NOV18F',
'NOV18H',
'NOV18J',
'NOV18E',
'RRHS19',
'LIB392',
'YAF181',
'NOV18C',
'NOV18M',
'NOV18B',
'NOV18A',
'FALLL6',
'FALLL5',
'FALLL4',
'NCCONF19',
'FALLL3',
'FALLL2',
'FALLL1',
'YAF179',
'CAL8PR',
'CAMP04',
'YAF137',
'K0801A',
'AFPC8',
'AFCCZ8',
'AFCC18',
'NFORGET',
'FREENT18',
'BENVTY',
'FB2018',
'CEFE18',
'HSP18G',
'RNH18C',
'NJCG18',
'PC2018',
'RNCH18',
'RCTR18',
'GEN18E',
'GENE18',
'RFOREMAN',
'YAF170',
'USA16C',
'US16C3',
'US16C2',
'CRAMHJ',
'EUSA16',
'US16B3',
'USA16B',
'US16B2',
'L0501A',
'US16A2',
'USA16A',
'NCSG16',
'RRHS16',
'MULTZ',
'NJC16I',
'CRAMPC',
'HS164',
'CLDR16',
'HS163',
'HS162',
'HDL006AB',
'HDL005AB',
'HDL004AB',
'HDL003AB',
'HDL002AB',
'HDL001AB',
'EOY171',
'NCSC40G',
'M0801A',
'EOY173',
'EOY172',
'ATCONF',
'LIB382',
'NOV17K',
'NOV17J',
'HDL006AA',
'HDL005AA',
'HDL004AA',
'HDL003AA',
'YAF144',
'YAF143',
'LO401A',
'L0401A',
'HS161',
'LMF001',
'COLLGZ',
'COLLG2',
'COLLG1',
'COLLG4',
'YAF142',
'RID16',
'COLLG3',
'COLLG6',
'PR2008',
'PR2007',
'PR2006',
'PR2005',
'PR2004',
'PR2003',
'HDL002AA',
'HDL001AA',
'YAF169',
'WSJ001',
'NOV17M',
'NOV17H',
'NOV17G',
'NOV17F',
'NOV17E',
'NOV17D',
'NOV17C',
'NOV17B',
'NOV17A',
'PR2002',
'PR2001',
'COLLG5',
'L0301A',
'SPEAK3',
'L0201A',
'LIB371',
'RWHD16',
'SPEAK2',
'NJC50A',
'MIN001',
'LHLDVD',
'LGLDVD',
'LJLDVD',
'LFLDVD',
'LCLDVD',
'LDLDVD',
'LBLDVD',
'LELDVD',
'LALDVD',
'FSL010',
'NOV19J',
'NOV19K',
'NOV19E',
'NOV19M',
'NOV19B',
'NOV19H',
'NOV19G',
'NOV19A',
'FSL009',
'FSL008',
'FSL007',
'FSL006',
'LDHDL06',
'NOV19F',
'NOV19C',
'NOV19D',
'FSL005',
'FSL003',
'FSL002',
'FSL001',
'FSL004',
'LIB402',
'FAL196',
'RGNLRW',
'FAL195',
'LD1BR1',
'YAF194',
'FAL194',
'FAL191',
'FAL192',
'FAL193',
'CRAMKL',
'RGNL25',
'RGNL20',
'YAF193',
'RGNL19',
'CRAMKK',
'K0201A',
'BCHD15',
'AFLPW5',
'NJC44A',
'RWHD15',
'BTL001',
'YAF128',
'K0101A',
'AFLLZ5',
'NJC43A',
'AFLLX5',
'AFLPG5',
'YAF127',
'AFCCX5',
'AFPCT5',
'AFPCX5',
'AFLPD5',
'AFPCZ5',
'SEMNRFF',
'RGNL35',
'RGNL59',
'LDY3HT',
'PAV001',
'LDY1ML',
'CAL9PR',
'CAL9VC',
'CAL9VB',
'CAL9C',
'CAL9B',
'HAYK19',
'YAF192',
'ENDOW15',
'CEFE15',
'EFT15',
'FC2015',
'NJCG15',
'RNH15C',
'HSP15G',
'RNCH15',
'RCTR15',
'GEN15E',
'GENE15',
'YAF126',
'J1201A',
'J1101A',
'CIS001',
'FTU001',
'LIB353',
'NDC22B',
'NDC19B',
'NDC02B',
'NDC04B',
'PID: 464',
'NOV16M',
'K1001A',
'LD1MP09',
'LIB412B',
'LIB412A',
'RGLA20',
'NDC09B',
'NDC06B',
'NDC05B',
'NDC17B',
'NDC12B',
'NDC11B',
'NDC08B',
'NDC24B',
'NDC14B',
'NDC10B',
'SPEAK1',
'YAF141',
'AFDHT6',
'AFDHX6',
'L0101A',
'AFLLZ6',
'YAF140',
'AFLLX6',
'AFPCT6',
'AFLPD6',
'AFPCZ6',
'AFCCZ6',
'AFPCX6',
'AFLPG6',
'AFCCX6',
'ENDOW16',
'NJCH16',
'NJCG16',
'RCTR16',
'RNH16C',
'RNCH16',
'HSP16G',
'GEN16E',
'GENE16',
'YAF139',
'DEC153',
'DEC152',
'DEC151',
'NOVR99',
'FSPG15',
'CRAMMG',
'NOVR10',
'NOVR98',
'NOVR97',
'NOVR11',
'NOVR96',
'NOVR95',
'YAF138',
'NOVR94',
'USA006',
'USA010',
'GWP001',
'USA008',
'USA009',
'USA003',
'LIB361',
'USA007',
'USA005',
'USA004',
'CRAMGV',
'NJC47A',
'USA002',
'YAF133',
'K0401A',
'USA001',
'RRHS15',
'CRAMGU',
'JD0001',
'BEQU15',
'NCNNA',
'NCRNA',
'NCNBA',
'NCRBA',
'YAF131',
'KSCM01',
'NCNND',
'NCRND',
'NCNBD',
'NCRBD',
'NJC46A',
'SEF15',
'CLDR15',
'NCNBC',
'NCNBB',
'NCRBC',
'NCRBB',
'NCNNC',
'MMN001',
'SEMINAR',
'RRCAL8',
'NJC48A',
'TAX15',
'YAF134',
'COLL7B',
'COLL7A',
'BERKLS',
'COLL7C',
'NCSC17',
'CLDR17',
'COLL7D',
'CRAMHX',
'COLL7E',
'SHAP01',
'YAF158',
'L5LDVD',
'L4LDVD',
'L3LDVD',
'L2LDVD',
'CRR16B',
'TAX16',
'SUIT01',
'CRRGG',
'CRREE',
'CRRCC',
'CRR11',
'CRR00',
'CRR77',
'CRR66',
'CRR36',
'CRR26',
'CRR163',
'CRR162',
'CRR161',
'CRR16',
'YAF146',
'GOC001',
'NCDFW6',
'NCSFW6',
'M0701A',
'BERL01',
'RRHS18',
'BUMP01',
'YAF166',
'SINGL6',
'SINGL5',
'SINGL4',
'NJC53A',
'SINGL2',
'BAYB01',
'SINGL3',
'SINGL1',
'CRAMIC',
'CAL193',
'AHG001',
'CAL192',
'CAL191',
'YAF163',
'CAL190',
'CAL9A',
'ENDOWHS',
'WCLC2019',
'YAF191',
'BEQU19',
'AZCCZ9',
'AZPCD9',
'AZPC19',
'AZDHX9',
'AZDHT9',
'AZCC19',
'LD1NJC',
'YAF190',
'NCSC9C',
'NCSC9D',
'NCSC9B',
'NCSC9A',
'LDY1PA',
'YAF189',
'CLDR19',
'L1LDVD',
'SMITH',
'SANT01',
'M0301A',
'BEQU17',
'FEB171',
'FEB170',
'43878',
'FEB172',
'JEF001',
'AFDHT7',
'AFDHX7',
'EJS001',
'M0101A',
'RWHD17',
'YAF156',
'TEX01',
'TEX03',
'TEX02',
'TEXG17',
'NCCFW6',
'AZDHT6',
'AZDHX6',
'AZPCT6',
'AZLPD6',
'AZPCZ6',
'AZPCX6',
'YAF145',
'AZLPG6',
'AZCCZ6',
'AZCCX6',
'CRAMKE',
'LDWM19',
'FEB194',
'FEB193',
'HS2019',
'YAF187',
'FEB196',
'FEB195',
'AFLD7',
'AFPCT7',
'WIK001',
'AFPCD7',
'YAF155',
'RCTR17',
'AFPC7',
'PC2017',
'RNH17C',
'GEN17E',
'RNCH17',
'AFCCZ7',
'GENE17',
'ENDOW17',
'AFCC17',
'CE2017',
'L1101A',
'RRHS17',
'YAF154',
'FFCONF',
'TWODC1',
'FEB192',
'WNB001',
'FEB180',
'FEB191',
'LIB401',
'AFDHL9',
'YAF186',
'RWHD19',
'NCSC2019',
'AFDHT9',
'AFDHX9',
'AFCC19',
'AFDH20',
'AFPCT9',
'AFPCD9',
'YAF185',
'AFPC19',
'AFLD9',
'AFCCZ9',
'HSP17G',
'NJCG17',
'G25801',
'L1001A',
'YAF152',
'NOV16L',
'NOV16K',
'NOV16J',
'NOV16H',
'NOV16G',
'NOV16F',
'NOV16E',
'NOV16D',
'NOV16C',
'NOV16A',
'YAF151',
'BERN01',
'L0901A',
'PC2016',
'NJC51A',
'CE2019',
'FREENT19',
'FB2019',
'LIB373',
'TWODC2',
'TWODC3',
'CRAMHS',
'YAF153',
'NOV16B',
'G25807',
'G25816',
'G25819',
'G25814',
'G25813',
'G25812',
'G25809',
'G25808',
'G25806',
'G25804',
'G25818',
'G25817',
'G25802',
'FEB203',
'FEB201',
'FEB206',
'LD1BS1',
'FEB202',
'FEB207',
'AFPT20',
'AFLD20',
'LD1ASO',
'AFDT20',
'LD3MS1',
'AFPD20',
'AFCZ20',
'AFPC20',
'AFCC20',
'NASH20',
'RWHD20',
'FB2020',
'PC2020',
'NJCG20',
'YAF150',
'BEQU16',
'BERN07',
'BERN05',
'BERN03',
'CAL189',
'CAL188',
'CAL187',
'CAL186',
'CAL185',
'CAL184',
'CAL183',
'CAL182',
'CAL181',
'TAX17',
'KC0001',
'YAF160',
'KENNY3',
'HSAUG17',
'CAL8VC',
'CAL8VB',
'CAL8C',
'CAL8B',
'MINN03',
'MINN02',
'MINN01',
'CAL8A',
'RRTXT1',
'MINN04',
'CONFU3',
'YAF177',
'CONFU2',
'CONFU1',
'AZCCZ8',
'AZCC18',
'AZDHT8',
'AZDHX8',
'AZPCD8',
'AZPC8',
'RNH20C',
'RCTR20',
'RNCH20',
'LDWM20',
'HSP20G',
'GENE20',
'NCSC2020',
'YAF197',
'RTBL2020',
'EOY195',
'LIB403',
'EOY194',
'EOY193',
'EOY192',
'EOY191',
'CEFE19',
'RRHS20',
'YAF196',
'LDY3ER',
'FSL012',
'HSOCT17',
'KENY2B',
'KENY1B',
'KENY2A',
'LIB381',
'KENY1A',
'AZPC7',
'CRUZ001',
'AZCCZ7',
'AZDHT7',
'AZDHX7',
'AZCC17',
'AZPCD7',
'FN001',
'CRAMHY',
'YAF159',
'CAPHILL',
'CRAMVP',
'SFR03',
'SFR02',
'SFR01',
'CLDR18',
'YAF173',
'YPS001',
'NCSC8D',
'NCSC8C',
'NCSC8B',
'LIB391',
'FEB187',
'FEB186',
'YAF172',
'NCSC8A',
'FEB185',
'FEB184',
'FEB181',
'WCLC2018',
'RWHD18',
'FSL011',
'LDHDL99',
'LDHDL08',
'LDHDL07',
'LDHDL05',
'LDHDL04',
'LDHDL03',
'LDHDL02',
'LDHDL01',
'YAF195',
'RGLB20',
'SOCMEDIA',
'RGL50',
'LD1MK08',
'LD1CC08',
'FAL296',
'FAL292',
'FAL291',
'FAL293',
'CAL2PR',
'UMNLEGAL',
'FEB183',
'FEB182',
'YAF171',
'AFDHT8',
'AFLD8',
'AFDHX8',
'AFPCT8',
'NCSC2018',
'AFPCD8',
'FAL295',
'CAL2VC',
'CAL2VB',
'YAF203',
'FAL294',
'CAL2B',
'CONF2020',
'1619AH',
'CORC1',
'CAL2A',
'LD3FR7',
'RGL25',
'YAF202',
'JUN203',
'RGL35',
'JUN202',
'JUN201',
'RGL20',
'YAF201',
'LDY3CG',
'LIB411',
'EMER23',
'CLDR20',
'OPCTR',
'EMER22',
'LD1BTO',
'TXCR20',
'YAF200',
'LD3BS4',
'NCSC2B',
'NCSC2D',
'FREENT20',
'NCSC2C',
'EMER21',
'YAF199',
'FEB205',
'FEB204',
'EMER20',
'NCSC2A',
'CONFEE20',
'CFE06T',
'CFE13T',
'CFE13R',
'CFE12T',
'CFE12R',
'CFE11T',
'CFE11R',
'CFE08R',
'CFE08T',
'CFE14R',
'CFE07T',
'CFE22T',
'CFE22R',
'CFE14T',
'CFE07R',
'CFE20T',
'CFE20R',
'CFE15T',
'CFE15R',
'CFE19T',
'CFE19R',
'CFE24R',
'CFE05T',
'CFE05R',
'CFE17T',
'CFE17R',
'CFE26R',
'CFE26T',
'CFE16R',
'CFE16T',
'CFE21R',
'CFE21T',
'CFE25T',
'CFE25R',
'CFE23T',
'CFE23R',
'CFE24T',
'CST001',
'VID06T',
'VID02T',
'VID04T',
'VID01T',
'VID07T',
'VID08T',
'VID09T',
'VID03T',
'J1001A',
'CFE02T',
'CFE02R',
'CFE01T',
'CFE01R',
'CFE03T',
'CFE03R',
'CFE30R',
'CFE18R',
'CFE18T',
'CFE04T',
'CFE04R',
'CFE29T',
'CFE29R',
'CFE33T',
'CFE33R',
'CFE31T',
'CFE31R',
'CFE27T',
'CFE27R',
'CFE30T',
'CFE28R',
'CFE28T',
'CFE35R',
'HDP51',
'HDP52',
'HDP50',
'HDP59',
'HDP60',
'HDP49',
'HDP61',
'CFE09T',
'CFE09R',
'CFE10R',
'CFE10T',
'CFE06R',
'HDP56',
'HDP57',
'HDP58',
'HDP53',
'HDP54',
'HDP55',
'CAMP02',
'PC2015',
'CAMP01',
'AZLLZ5',
'AZLLX5',
'AZPCT5',
'AZLPG5',
'AZCCX5',
'AZLPD5',
'AZCCZ5',
'AZPCZ5',
'AZPCX5',
'YAF136',
'CRAMHO',
'LIB372',
'CRRFF',
'CRAMHN',
'ONE6',
'YAF148',
'ONE5',
'CRRDD',
'ONE4',
'CRR99',
'CRR88',
'ONE1',
'ONE2',
'ONE3',
'CRR56',
'CRR46',
'L0701A',
'YAF147',
'CRR16A',
'RRCA13',
'NJC49A',
'GBS15',
'FF2015',
'CATH15',
'RRCA11',
'RRCA12',
'RRCA10',
'RRCAL9',
'RRCAL7',
'K0701A',
'RRCAL6',
'RRCAL5',
'RRCAL4',
'RRCAL3',
'RRCAL2',
'RRCAL1',
'YAF135',
'MFA001',
'LECTUR',
'33329',
'SP',
'PN',
'33298',
'IQ',
'33390',
'RW01',
'RW',
'RR8A',
'RR07',
'33786',
'RR6B',
'33725',
'MAY292',
'RR05',
'33695',
'RR03',
'33664',
'MG',
'33635',
'GENE92',
'AR02',
'33573',
'SCHWAR',
'RR01',
'33543',
'YF9A',
'33512',
'33451',
'CHECK',
'YF8B',
'33482',
'POSTER',
'YF7A',
'PZ',
'DH',
'APR391',
'YF5A',
'APR291',
'YP',
'33270',
'YF11',
'GENE91',
'BBTAPE',
'RS01',
'YF02',
'34731',
'34700',
'RD01',
'GENE95',
'WFLECT',
'OVER94',
'YF01',
'34669',
'AP01',
'RR04',
'34455',
'APR294',
'YF0595',
'RR02',
'34394',
'FLOOD',
'34425',
'AS01',
'VID4PH',
'VID4YA',
'VID4YB',
'RR13',
'REPT25',
'34639',
'34608',
'GL01',
'34547',
'34578',
'RR0794',
'RR06',
'RR0594',
'34486',
'VID5D',
'44107',
'OCT03R',
'VID4PT',
'VID4PM',
'VID4PJ',
'WCLC03',
'FF2004',
'WQ0103',
'Y90103',
'NZMAT',
'LB1103',
'VID5G',
'VID5A',
'VID5C',
'VID5H',
'VID5E',
'VID5B',
'MRE03',
'SBHC03',
'NOV20J',
'CAL2C',
'NOV20H',
'WCLC2020',
'NOV20E',
'NOV20G',
'LD3ER10',
'YAF201',
'NOV20B',
'NOV20A',
'NOV20M',
'NOV20C',
'AWDAP001'
)
and
a.did in (
23978,
23981,
23986,
23989,
23991,
23993,
23995,
23999,
24000,
24005,
24006,
24009,
24016,
24021,
24022,
24026,
24027,
24030,
24042,
24044,
24045,
24047,
24049,
24051,
24053,
24054,
24055,
24056,
24061,
24062,
24064,
24066,
24071,
24073,
24074,
24075,
24076,
24079,
24082,
24084,
24086,
24090,
24092,
24094,
24096,
24098,
24102,
24105,
24107,
24110,
24111,
24112,
24113,
24115,
24118,
24120,
24129,
24270,
24381,
24427,
24525,
24572,
24663,
24700,
24734,
24833,
24882,
24932,
24965,
24986,
25084,
25171,
25212,
25227,
25277,
25328,
25442,
25499,
25628,
25832,
25881,
26019,
26085,
26110,
26168,
26303,
26347,
26365,
26608,
26691,
26804,
27056,
27072,
27195,
27223,
27256,
27258,
27670,
27809,
27867,
27869,
27942,
27953,
27960,
28073,
28134,
18688,
18721,
18728,
18927,
18985,
19044,
19071,
19079,
19176,
19313,
19343,
19434,
19452,
19588,
19646,
19647,
19664,
19816,
28196,
28232,
28302,
28350,
19903,
19965,
20011,
20069,
20194,
20245,
20546,
20598,
20855,
20862,
20871,
20928,
20980,
20984,
20988,
21018,
21077,
21189,
21313,
21336,
21356,
21392,
21427,
21502,
21514,
21571,
21752,
21864,
21914,
21986,
22044,
22210,
22370,
22413,
22518,
22538,
22544,
22575,
22602,
22620,
22640,
22668,
22711,
22790,
22891,
23050,
23102,
23298,
23330,
23597,
23639,
23672,
23809,
23838,
23907,
23910,
23915,
23919,
23920,
23921,
23927,
23932,
23935,
23936,
23948,
23950,
23959,
23960,
23965,
23968,
23970,
23976,
4831,
5385,
5596,
5922,
5926,
5981,
6149,
6217,
6250,
6348,
6373,
6486,
6695,
6784,
6810,
6874,
6911,
7182,
7320,
7372,
7424,
7446,
7507,
7675,
7706,
7912,
7923,
7936,
8101,
8158,
8226,
8367,
8442,
8461,
8726,
8901,
8914,
8918,
9247,
9297,
154,
341,
385,
523,
541,
614,
635,
702,
780,
994,
1004,
1116,
1123,
1453,
1457,
1635,
1681,
1815,
1979,
1985,
1993,
2020,
2083,
2119,
2176,
2236,
2462,
2484,
2611,
2762,
3086,
3215,
3255,
3418,
3856,
4071,
4176,
4399,
4792,
9444,
9460,
9605,
9843,
9858,
9859,
9875,
9988,
10056,
10067,
10079,
10118,
10154,
10181,
10371,
10373,
10407,
10512,
10561,
10820,
10900,
10929,
10971,
11148,
11155,
11199,
11370,
11423,
11458,
11537,
11655,
11677,
11945,
12104,
12143,
12307,
12320,
12336,
12343,
12357,
12455,
12487,
12508,
12513,
12544,
12548,
12553,
12713,
12773,
12847,
12909,
13028,
13045,
13048,
13050,
13221,
13260,
13291,
13304,
13413,
13678,
13860,
13888,
13933,
14040,
14062,
14094,
14133,
14169,
14205,
14226,
14300,
14392,
14397,
14457,
14656,
14707,
14783,
14837,
14857,
14916,
15250,
15510,
15555,
15596,
15650,
15722,
15837,
15986,
16068,
16218,
16227,
16305,
16337,
16346,
16394,
16468,
16787,
16804,
16886,
17157,
17383,
17416,
17814,
17981,
17982,
17998,
18027,
18085,
18162,
18205,
18275,
18354,
18379,
18395,
18404,
18418,
18426,
18453,
18480,
18523,
30734,
30870,
31020,
31070,
31135,
31157,
31190,
31207,
31216,
31299,
31410,
31435,
31586,
31695,
31719,
31754,
31778,
31825,
31878,
31923,
32003,
32146,
32382,
32456,
32485,
32558,
32563,
32744,
32756,
32764,
32779,
32782,
32795,
32871,
32913,
33032,
33360,
33395,
33483,
33520,
33536,
33564,
33573,
33605,
33632,
33633,
33642,
33653,
33676,
33710,
33818,
33957,
33968,
33992,
34032,
34040,
34052,
34086,
34093,
34100,
34140,
34187,
34278,
34296,
34408,
34466,
28361,
28378,
28565,
28657,
28680,
28721,
28731,
28799,
28885,
28912,
28931,
29035,
29036,
29195,
29200,
29228,
29245,
29284,
29305,
29309,
29315,
29342,
29407,
29437,
29546,
29594,
29628,
29667,
29668,
29744,
29781,
30123,
30395,
30668
)




