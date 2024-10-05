import Foundation

enum Country: String, CaseIterable, Identifiable, Codable {
    case afghanistan = "Afghanistan"
    case albania = "Albania"
    case algeria = "Algeria"
    case andorra = "Andorra"
    case angola = "Angola"
    case antiguaAndBarbuda = "Antigua and Barbuda"
    case argentina = "Argentina"
    case armenia = "Armenia"
    case australia = "Australia"
    case austria = "Austria"
    case azerbaijan = "Azerbaijan"
    case bahamas = "Bahamas"
    case bahrain = "Bahrain"
    case bangladesh = "Bangladesh"
    case barbados = "Barbados"
    case belarus = "Belarus"
    case belgium = "Belgium"
    case belize = "Belize"
    case benin = "Benin"
    case bhutan = "Bhutan"
    case bolivia = "Bolivia"
    case bosniaAndHerzegovina = "Bosnia and Herzegovina"
    case botswana = "Botswana"
    case brazil = "Brazil"
    case brunei = "Brunei"
    case bulgaria = "Bulgaria"
    case burkinaFaso = "Burkina Faso"
    case burundi = "Burundi"
    case caboVerde = "Cabo Verde"
    case cambodia = "Cambodia"
    case cameroon = "Cameroon"
    case canada = "Canada"
    case centralAfricanRepublic = "Central African Republic"
    case chad = "Chad"
    case chile = "Chile"
    case china = "China"
    case colombia = "Colombia"
    case comoros = "Comoros"
    case congoBrazzaville = "Congo (Congo-Brazzaville)"
    case congoKinshasa = "Congo, Democratic Republic of the"
    case costaRica = "Costa Rica"
    case croatia = "Croatia"
    case cuba = "Cuba"
    case cyprus = "Cyprus"
    case czechRepublic = "Czech Republic"
    case denmark = "Denmark"
    case djibouti = "Djibouti"
    case dominica = "Dominica"
    case dominicanRepublic = "Dominican Republic"
    case eastTimor = "East Timor (Timor-Leste)"
    case ecuador = "Ecuador"
    case egypt = "Egypt"
    case elSalvador = "El Salvador"
    case equatorialGuinea = "Equatorial Guinea"
    case eritrea = "Eritrea"
    case estonia = "Estonia"
    case eswatini = "Eswatini (Swaziland)"
    case ethiopia = "Ethiopia"
    case fiji = "Fiji"
    case finland = "Finland"
    case france = "France"
    case gabon = "Gabon"
    case gambia = "Gambia"
    case georgia = "Georgia"
    case germany = "Germany"
    case ghana = "Ghana"
    case greece = "Greece"
    case grenada = "Grenada"
    case guatemala = "Guatemala"
    case guinea = "Guinea"
    case guineaBissau = "Guinea-Bissau"
    case guyana = "Guyana"
    case haiti = "Haiti"
    case honduras = "Honduras"
    case hungary = "Hungary"
    case iceland = "Iceland"
    case india = "India"
    case indonesia = "Indonesia"
    case iran = "Iran"
    case iraq = "Iraq"
    case ireland = "Ireland"
    case israel = "Israel"
    case italy = "Italy"
    case ivoryCoast = "Ivory Coast (Côte d'Ivoire)"
    case jamaica = "Jamaica"
    case japan = "Japan"
    case jordan = "Jordan"
    case kazakhstan = "Kazakhstan"
    case kenya = "Kenya"
    case kiribati = "Kiribati"
    case northKorea = "Korea, North"
    case southKorea = "Korea, South"
    case kosovo = "Kosovo"
    case kuwait = "Kuwait"
    case kyrgyzstan = "Kyrgyzstan"
    case laos = "Laos"
    case latvia = "Latvia"
    case lebanon = "Lebanon"
    case lesotho = "Lesotho"
    case liberia = "Liberia"
    case libya = "Libya"
    case liechtenstein = "Liechtenstein"
    case lithuania = "Lithuania"
    case luxembourg = "Luxembourg"
    case madagascar = "Madagascar"
    case malawi = "Malawi"
    case malaysia = "Malaysia"
    case maldives = "Maldives"
    case mali = "Mali"
    case malta = "Malta"
    case marshallIslands = "Marshall Islands"
    case mauritania = "Mauritania"
    case mauritius = "Mauritius"
    case mexico = "Mexico"
    case micronesia = "Micronesia"
    case moldova = "Moldova"
    case monaco = "Monaco"
    case mongolia = "Mongolia"
    case montenegro = "Montenegro"
    case morocco = "Morocco"
    case mozambique = "Mozambique"
    case myanmar = "Myanmar (Burma)"
    case namibia = "Namibia"
    case nauru = "Nauru"
    case nepal = "Nepal"
    case netherlands = "Netherlands"
    case newZealand = "New Zealand"
    case nicaragua = "Nicaragua"
    case niger = "Niger"
    case nigeria = "Nigeria"
    case northMacedonia = "North Macedonia"
    case norway = "Norway"
    case oman = "Oman"
    case pakistan = "Pakistan"
    case palau = "Palau"
    case panama = "Panama"
    case papuaNewGuinea = "Papua New Guinea"
    case paraguay = "Paraguay"
    case peru = "Peru"
    case philippines = "Philippines"
    case poland = "Poland"
    case portugal = "Portugal"
    case qatar = "Qatar"
    case romania = "Romania"
    case russia = "Russia"
    case rwanda = "Rwanda"
    case saintKittsAndNevis = "Saint Kitts and Nevis"
    case saintLucia = "Saint Lucia"
    case saintVincentAndTheGrenadines = "Saint Vincent and the Grenadines"
    case samoa = "Samoa"
    case sanMarino = "San Marino"
    case saoTomeAndPrincipe = "São Tomé and Príncipe"
    case saudiArabia = "Saudi Arabia"
    case senegal = "Senegal"
    case serbia = "Serbia"
    case seychelles = "Seychelles"
    case sierraLeone = "Sierra Leone"
    case singapore = "Singapore"
    case slovakia = "Slovakia"
    case slovenia = "Slovenia"
    case solomonIslands = "Solomon Islands"
    case somalia = "Somalia"
    case southAfrica = "South Africa"
    case southSudan = "South Sudan"
    case spain = "Spain"
    case sriLanka = "Sri Lanka"
    case sudan = "Sudan"
    case suriname = "Suriname"
    case sweden = "Sweden"
    case switzerland = "Switzerland"
    case syria = "Syria"
    case taiwan = "Taiwan"
    case tajikistan = "Tajikistan"
    case tanzania = "Tanzania"
    case thailand = "Thailand"
    case togo = "Togo"
    case tonga = "Tonga"
    case trinidadAndTobago = "Trinidad and Tobago"
    case tunisia = "Tunisia"
    case turkey = "Turkey"
    case turkmenistan = "Turkmenistan"
    case tuvalu = "Tuvalu"
    case uganda = "Uganda"
    case ukraine = "Ukraine"
    case unitedArabEmirates = "United Arab Emirates"
    case unitedKingdom = "United Kingdom"
    case unitedStates = "United States"
    case uruguay = "Uruguay"
    case uzbekistan = "Uzbekistan"
    case vanuatu = "Vanuatu"
    case vaticanCity = "Vatican City"
    case venezuela = "Venezuela"
    case vietnam = "Vietnam"
    case yemen = "Yemen"
    case zambia = "Zambia"
    case zimbabwe = "Zimbabwe"
    
    var id: String { self.rawValue }
    
    var countryCode: String {
        switch self {
            case .afghanistan:
            return "AF"
            case .albania:
            return "AL"
            case .algeria:
            return "DZ"
            case .andorra:
            return "AD"
            case .angola:
            return "AO"
            case .antiguaAndBarbuda:
            return "AG"
            case .argentina:
            return "AR"
            case .armenia:
            return "AM"
            case .australia:
            return "AU"
            case .austria:
            return "AT"
            case .azerbaijan:
            return "AZ"
            case .bahamas:
            return "BS"
            case .bahrain:
            return "BH"
            case .bangladesh:
            return "BD"
            case .barbados:
            return "BB"
            case .belarus:
            return "BY"
            case .belgium:
            return "BE"
            case .belize:
            return "BZ"
            case .benin:
            return "BJ"
            case .bhutan:
            return "BT"
            case .bolivia:
            return "BO"
            case .bosniaAndHerzegovina:
            return "BA"
            case .botswana:
            return "BW"
            case .brazil:
            return "BR"
            case .brunei:
            return "BN"
            case .bulgaria:
            return "BG"
            case .burkinaFaso:
            return "BF"
            case .burundi:
            return "BI"
            case .caboVerde:
            return "CV"
            case .cambodia:
            return "KH"
            case .cameroon:
            return "CM"
            case .canada:
            return "CA"
            case .centralAfricanRepublic:
            return "CF"
            case .chad:
            return "TD"
            case .chile:
            return "CL"
            case .china:
            return "CN"
            case .colombia:
            return "CO"
            case .comoros:
            return "KM"
            case .congoBrazzaville:
            return "CG"
            case .congoKinshasa:
            return "CD"
            case .costaRica:
            return "CR"
            case .croatia:
            return "HR"
            case .cuba:
            return "CU"
            case .cyprus:
            return "CY"
            case .czechRepublic:
            return "CZ"
            case .denmark:
            return "DK"
            case .djibouti:
            return "DJ"
            case .dominica:
            return "DM"
            case .dominicanRepublic:
            return "DO"
            case .eastTimor:
            return "TL"
            case .ecuador:
            return "EC"
            case .egypt:
            return "EG"
            case .elSalvador:
            return "SV"
            case .equatorialGuinea:
            return "GQ"
            case .eritrea:
            return "ER"
            case .estonia:
            return "EE"
            case .eswatini:
            return "SZ"
            case .ethiopia:
            return "ET"
            case .fiji:
            return "FJ"
            case .finland:
            return "FI"
            case .france:
            return "FR"
            case .gabon:
            return "GA"
            case .gambia:
            return "GM"
            case .georgia:
            return "GE"
            case .germany:
            return "DE"
            case .ghana:
            return "GH"
            case .greece:
            return "GR"
            case .grenada:
            return "GD"
            case .guatemala:
            return "GT"
            case .guinea:
            return "GN"
            case .guineaBissau:
            return "GW"
            case .guyana:
            return "GY"
            case .haiti:
            return "HT"
            case .honduras:
            return "HN"
            case .hungary:
            return "HU"
            case .iceland:
            return "IS"
            case .india:
            return "IN"
            case .indonesia:
            return "ID"
            case .iran:
            return "IR"
            case .iraq:
            return "IQ"
            case .ireland:
            return "IE"
            case .israel:
            return "IL"
            case .italy:
            return "IT"
            case .ivoryCoast:
            return "CI"
            case .jamaica:
            return "JM"
            case .japan:
            return "JP"
            case .jordan:
            return "JO"
            case .kazakhstan:
            return "KZ"
            case .kenya:
            return "KE"
            case .kiribati:
            return "KI"
            case .northKorea:
            return "KP"
            case .southKorea:
            return "KR"
            case .kosovo:
            return "XK"
            case .kuwait:
            return "KW"
            case .kyrgyzstan:
            return "KG"
            case .laos:
            return "LA"
            case .latvia:
            return "LV"
            case .lebanon:
            return "LB"
            case .lesotho:
            return "LS"
            case .liberia:
            return "LR"
            case .libya:
            return "LY"
            case .liechtenstein:
            return "LI"
            case .lithuania:
            return "LT"
            case .luxembourg:
            return "LU"
            case .madagascar:
            return "MG"
            case .malawi:
            return "MW"
            case .malaysia:
            return "MY"
            case .maldives:
            return "MV"
            case .mali:
            return "ML"
            case .malta:
            return "MT"
            case .marshallIslands:
            return "MH"
            case .mauritania:
            return "MR"
            case .mauritius:
            return "MU"
            case .mexico:
            return "MX"
            case .micronesia:
            return "FM"
            case .moldova:
            return "MD"
            case .monaco:
            return "MC"
            case .mongolia:
            return "MN"
            case .montenegro:
            return "ME"
            case .morocco:
            return "MA"
            case .mozambique:
            return "MZ"
            case .myanmar:
            return "MM"
            case .namibia:
            return "NA"
            case .nauru:
            return "NR"
            case .nepal:
            return "NP"
            case .netherlands:
            return "NL"
            case .newZealand:
            return "NZ"
            case .nicaragua:
            return "NI"
            case .niger:
            return "NE"
            case .nigeria:
            return "NG"
            case .northMacedonia:
            return "MK"
            case .norway:
            return "NO"
            case .oman:
            return "OM"
            case .pakistan:
            return "PK"
            case .palau:
            return "PW"
            case .panama:
            return "PA"
            case .papuaNewGuinea:
            return "PG"
            case .paraguay:
            return "PY"
            case .peru:
            return "PE"
            case .philippines:
            return "PH"
            case .poland:
            return "PL"
            case .portugal:
            return "PT"
            case .qatar:
            return "QA"
            case .romania:
            return "RO"
            case .russia:
            return "RU"
            case .rwanda:
            return "RW"
            case .saintKittsAndNevis:
            return "KN"
            case .saintLucia:
            return "LC"
            case .saintVincentAndTheGrenadines:
            return "VC"
            case .samoa:
            return "WS"
            case .sanMarino:
            return "SM"
            case .saoTomeAndPrincipe:
            return "ST"
            case .saudiArabia:
            return "SA"
            case .senegal:
            return "SN"
            case .serbia:
            return "RS"
            case .seychelles:
            return "SC"
            case .sierraLeone:
            return "SL"
            case .singapore:
            return "SG"
            case .slovakia:
            return "SK"
            case .slovenia:
            return "SI"
            case .solomonIslands:
            return "SB"
            case .somalia:
            return "SO"
            case .southAfrica:
            return "ZA"
            case .southSudan:
            return "SS"
            case .spain:
            return "ES"
            case .sriLanka:
            return "LK"
            case .sudan:
            return "SD"
            case .suriname:
            return "SR"
            case .sweden:
            return "SE"
            case .switzerland:
            return "CH"
            case .syria:
            return "SY"
            case .taiwan:
            return "TW"
            case .tajikistan:
            return "TJ"
            case .tanzania:
            return "TZ"
            case .thailand:
            return "TH"
            case .togo:
            return "TG"
            case .tonga:
            return "TO"
            case .trinidadAndTobago:
            return "TT"
            case .tunisia:
            return "TN"
            case .turkey:
            return "TR"
            case .turkmenistan:
            return "TM"
            case .tuvalu:
            return "TV"
            case .uganda:
            return "UG"
            case .ukraine:
            return "UA"
            case .unitedArabEmirates:
            return "AE"
            case .unitedKingdom:
            return "GB"
            case .unitedStates:
            return "US"
            case .uruguay:
            return "UY"
            case .uzbekistan:
            return "UZ"
            case .vanuatu:
            return "VU"
            case .vaticanCity:
            return "VA"
            case .venezuela:
            return "VE"
            case .vietnam:
            return "VN"
            case .yemen:
            return "YE"
            case .zambia:
            return "ZM"
            case .zimbabwe:
            return "ZW"
        }
    }
}
