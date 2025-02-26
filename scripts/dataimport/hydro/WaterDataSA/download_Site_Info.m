function sdata =  download_Site_Info


sites = all_sites;

sdata = [];

for ii = 1:length(sites)
    
    %disp(lower(sites{ii}));
    
    site_txt = 'https://apps.waterconnect.sa.gov.au/SiteInfo/Data/Site_Data/';
    
    address = [site_txt,lower(sites{ii}),'/w01.htm'];
    
    
    
    try
        tt = urlwrite(address,'test.txt','Timeout',10);
        
        fid = fopen('test.txt','rt');
        
        for i = 1:15
            line = fgetl(fid);
        end
        line = fgetl(fid);
        sdata.(sites{ii}).disc = line(27:end);
        
        for i = 1:3
            line = fgetl(fid);
        end
        line = fgetl(fid);
        line_spt = strsplit(line,' ');
        sdata.(sites{ii}).X = str2num(line_spt{6});
        sdata.(sites{ii}).Y = str2num(line_spt{8});
        
        fclose(fid);
        
        
        
    catch
        
        disp('Site information not found')
    end
    
    
end

end

function sites = all_sites

sites = {...
    'A4261156',...
    'A4261124',...
    'A4261133',...
    'A4261158',...
    'A0211006'...
'A0040518'...
'A0040519'...
'A0040517'...
'A0040522'...
'A0040521'...
'A4260637'...
'A4260647'...
'A4260665'...
'A2390567'...
'A2391088'...
'A2391087'...
'A2391089'...
'A2391094'...
'A2391102'...
'A2391103'...
'A2391109'...
'A2391143'...
'A2391184'...
'A4260646'...
'A4260694'...
'A4260904'...
'A4261167'...
'A4261221'...
'A0211001'...
'A0211003'...
'A0211002'...
'A0211004'...
'A2391090'...
'A2391091'...
'A2391260'...
'A4260603'...
'A4260639'...
'A4260638'...
'A4261015'...
'A4261021'...
'A5121002'...
'A5121004'...
'A5121003'...
'A5121005'...
'A5121008'...
'A5121007'...
'A5020504'...
'A5030534'...
'A5040550'...
'A5040553'...
'A5040555'...
'A5040557'...
'A5040551'...
'A5040565'...
'A5040567'...
'A5040564'...
'A5070509'...
'A5070508'...
'A5080505'...
'A5100512'...
'A5100514'...
'A5100513'...
'A5100515'...
'A5120507'...
'A5030533'...
'A5030532'...
'A5011018'...
'A5011025'...
'A5011026'...
'A5131017'...
'A5131016'...
'A5130505'...
'A5050539'...
'A5050537'...
'A5050538'...
'A5061009'...
'A5120508'...
'A5100516'...
'A5091003'...
'A5090505'...
'A5080504'...
'A5070507'...
'A5070506'...
'A5040563'...
'A5040559'...
'A5040552'...
'A5040558'...
'A5041059'...
'A5011032'...
'A5011033'...
'A5011034'...
'A0020101'...
'A2390534'...
'A4260510'...
'A4260512'...
'A4260514'...
'A4260516'...
'A4260518'...
'A4260524'...
'A4260525'...
'A4260527'...
'A4260554'...
'A4260574'...
'A4260575'...
'A4260630'...
'A4260633'...
'A4260902'...
'A4261034'...
'A4261041'...
'A4261042'...
'A4261044'...
'A4261045'...
'A4261046'...
'A4261047'...
'A4261048'...
'A4261123'...
'A4261133'...
'A4261134'...
'A4261135'...
'A4261153'...
'A4261155'...
'A4261156'...
'A4261162'...
'A4261165'...
'A4261207'...
'A4261209'...
'A5050502'...
'A5040583'...
'A0030501'...
'A0040502'...
'A2391001'...
'A2390515'...
'A2390510'...
'A2390513'...
'A2390512'...
'A2390514'...
'A2390517'...
'A2390516'...
'A2390519'...
'A2390518'...
'A5050501'...
'A5050500'...
'A5050503'...
'A5050504'...
'A5050510'...
'A5050512'...
'A5050517'...
'A5050518'...
'A5050516'...
'A0021001'...
'A0021002'...
'A0021003'...
'A0021004'...
'A0031002'...
'A0031001'...
'A0031003'...
'A0031004'...
'A0040508'...
'A0040520'...
'A0041004'...
'A0041002'...
'A0041007'...
'A0041012'...
'A0041010'...
'A0041011'...
'A4260520'...
'A4260521'...
'A4260522'...
'A4260529'...
'A4260536'...
'A4260544'...
'A4260546'...
'A4260545'...
'A4260548'...
'A4260547'...
'A4260549'...
'A4260569'...
'A4260583'...
'A4260629'...
'A4260662'...
'A4260661'...
'A4260664'...
'A4261008'...
'A4261009'...
'A4261010'...
'A4261012'...
'A4261013'...
'A4261028'...
'A4261037'...
'A4261040'...
'A4261049'...
'A4261069'...
'A4261076'...
'A4261078'...
'A4261125'...
'A4261130'...
'A2390504'...
'A2390505'...
'A2390506'...
'A2390508'...
'A2390521'...
'A2390524'...
'A2390523'...
'A2390526'...
'A2390527'...
'A2390529'...
'A2390532'...
'A2390533'...
'A2390531'...
'A2390535'...
'A2390537'...
'A2390536'...
'A2390541'...
'A2390542'...
'A2390543'...
'A2390545'...
'A2390546'...
'A2390549'...
'A2390551'...
'A2390556'...
'A2390562'...
'A2390565'...
'A2390563'...
'A2390564'...
'A2390569'...
'A2390568'...
'A2391007'...
'A2391010'...
'A2391023'...
'A2391026'...
'A2391061'...
'A2391066'...
'A2391068'...
'A2391067'...
'A2391069'...
'A2391070'...
'A2391072'...
'A2391073'...
'A2391074'...
'A2391075'...
'A2391076'...
'A2391077'...
'A2391080'...
'A2391081'...
'A2391082'...
'A2391084'...
'A2391083'...
'A2391085'...
'A2391086'...
'A2391092'...
'A2391095'...
'A2391101'...
'A2391106'...
'A2391104'...
'A2391107'...
'A2391105'...
'A2391108'...
'A2391125'...
'A2391140'...
'A2391141'...
'A2391142'...
'A2391146'...
'A2391144'...
'A2391147'...
'A2391145'...
'A2391148'...
'A2391149'...
'A2391150'...
'A2391151'...
'A2391154'...
'A2391152'...
'A2391153'...
'A2391186'...
'A2391187'...
'A2391185'...
'A2391188'...
'A2391259'...
'A4260634'...
'A4140211'...
'A4140215'...
'A4260200'...
'A4250010'...
'A4260500'...
'A4260501'...
'A4260502'...
'A4260505'...
'A4260506'...
'A4260508'...
'A4260507'...
'A4260509'...
'A4260513'...
'A4260511'...
'A4260515'...
'A4260517'...
'A4260519'...
'A4260528'...
'A4260532'...
'A4260535'...
'A4260537'...
'A4260539'...
'A4260542'...
'A4260550'...
'A4260552'...
'A4260553'...
'A4260556'...
'A4260573'...
'A4260576'...
'A4260578'...
'A4260579'...
'A4260580'...
'A4260584'...
'A4260586'...
'A4260585'...
'A4260588'...
'A4260587'...
'A4260594'...
'A4260593'...
'A4260596'...
'A4260595'...
'A4260597'...
'A4260600'...
'A4260601'...
'A4260624'...
'A4260628'...
'A4260632'...
'A4260635'...
'A4260640'...
'A4260641'...
'A4260643'...
'A4260642'...
'A4260644'...
'A4260645'...
'A4260652'...
'A4260663'...
'A4260701'...
'A4260702'...
'A4260703'...
'A4260704'...
'A4260705'...
'A4260903'...
'A4261001'...
'A4261003'...
'A4261004'...
'A4261023'...
'A4261022'...
'A4261024'...
'A4261025'...
'A4261027'...
'A4261031'...
'A4261032'...
'A4261033'...
'A4261051'...
'A4261052'...
'A4261053'...
'A4261055'...
'A4261056'...
'A4261057'...
'A4261059'...
'A4261064'...
'A4261065'...
'A4261068'...
'A4261066'...
'A4261067'...
'A4261083'...
'A4261086'...
'A4261087'...
'A4261088'...
'A4261090'...
'A4261091'...
'A4261093'...
'A4261092'...
'A4261106'...
'A4261107'...
'A4261108'...
'A4261110'...
'A4261109'...
'A4261127'...
'A4261126'...
'A4261148'...
'A4261159'...
'A4261160'...
'A4261161'...
'A4261163'...
'A4261164'...
'A4261166'...
'A4261168'...
'A4261170'...
'A4261200'...
'A4261199'...
'A4261201'...
'A4261224'...
'A4261225'...
'A4261244'...
'A4261247'...
'A4261245'...
'A4261248'...
'A4261246'...
'A4261255'...
'A4261263'...
'A4261265'...
'A4261262'...
'A4261264'...
'A4261268'...
'A4261271'...
'A4261270'...
'A4261272'...
'A4261278'...
'A0021005'...
'A0031007'...
'A0041003'...
'A0041006'...
'A0051003'...
'A2391257'...
'A4260504'...
'A4260503'...
'A4260530'...
'A4260533'...
'A4260557'...
'A4260558'...
'A4260572'...
'A4260605'...
'A4260679'...
'A4260688'...
'A4261018'...
'A4261036'...
'A4261039'...
'A4261043'...
'A4261099'...
'A4261101'...
'A4261122'...
'A4261124'...
'A4261128'...
'A4261129'...
'A4261157'...
'A4261158'...
'A4261202'...
'A4261203'...
'A4261204'...
'A4261205'...
'A4261206'...
'A4261208'...
'A4261219'...
'A4261222'...
'A4261220'...
'A4261223'...
'A4260658'...
'A4260659'...
'A4260660'...
'A2391137'...
'A4261030'...
'A4261011'...
'A4261406'...
'A4261407'...
'A5050533'...
'A4261172'...
'A4261173'...
'A4261174'...
'A4261269'...
'A4261520'...
'A4261521'...
'A4261522'...
'A4261536'...
'A4261539'...
'A4261540'...
'A5011015'...
'A5011021'...
'A5011020'...
'A5011024'...
'A5011022'...
'A5011037'...
'A5011038'...
'A5011041'...
'A5011042'...
'A5020501'...
'A5030501'...
'A5030502'...
'A5030504'...
'A5040520'...
'A5040528'...
'A5040531'...
'A5040547'...
'A5040592'...
'A5041011'...
'A5041009'...
'A5041013'...
'A5041012'...
'A5041016'...
'A5041014'...
'A5041017'...
'A5041042'...
'A5041041'...
'A5041045'...
'A5041046'...
'A5041052'...
'A5041051'...
'A5050540'...
'A5051021'...
'A5061010'...
'A5070502'...
'A5071005'...
'A5080500'...
'A5100500'...
'A5100503'...
'A5130502'...
'A5131020'...
'A5131021'...
'A5131023'...
'A5131022'...
'A5131024'...
'A5131025'...
'A5131026'...
'A5131041'...
'A5011011'...
'A5011008'...
'A5020500'...
'A5030505'...
'A5030521'...
'A5030522'...
'A5030524'...
'A5030531'...
'A5030530'...
'A5030528'...
'A5030545'...
'A5030546'...
'A5040504'...
'A5040509'...
'A5040541'...
'A5040544'...
'A5040546'...
'A5040518'...
'A5040521'...
'A5040530'...
'A5040554'...
'A5040576'...
'A5040579'...
'A5040582'...
'A5040561'...
'A5040580'...
'A5040581'...
'A5041019'...
'A5041018'...
'A5050505'...
'A5050522'...
'A5050527'...
'A5050541'...
'A5050544'...
'A5051007'...
'A5051008'...
'A5051009'...
'A5080503'...
'A5090501'...
'A5090504'...
'A5100502'...
'A5100507'...
'A5100510'...
'A5100511'...
'A5120504'...
'A5120505'...
'A5011010'...
'A5011009'...
'A5011014'...
'A5011007'...
'A5010503'...
'A5011006'...
'A5030537'...
'A5030529'...
'A5030503'...
'A5131014'...
'A5131015'...
'A5131001'...
'A5131002'...
'A5131003'...
'A5131007'...
'A5050542'...
'A5050535'...
'A5060500'...
'A5060501'...
'A5061001'...
'A5061002'...
'A5061004'...
'A5061003'...
'A5061005'...
'A5061006'...
'A5061007'...
'A5061008'...
'A5070500'...
'A5050532'...
'A5130501'...
'A5120500'...
'A5120503'...
'A5091001'...
'A5091002'...
'A5090503'...
'A5090502'...
'A5070901'...
'A5071002'...
'A5071003'...
'A5071004'...
'A5070501'...
'A5070503'...
'A5041003'...
'A5030525'...
'A5040512'...
'A5040503'...
'A5040500'...
'A5040501'...
'A5040508'...
'A5031010'...
'A5030547'...
'A5031001'...
'A5031004'...
'A5031005'...
'A5031006'...
'A5031007'...
'A5031009'...
'A5031008'...
'A5040523'...
'A5040549'...
'A5040525'...
'A5040529'...
'A5040578'...
'A5040901'...
'A5041022'...
'A5041021'...
'A5041024'...
'A5041023'...
'A5041025'...
'A5041020'...
'A5041005'...
'A5050536'...
'A5050543'...
'A5051004'...
'A5051003'...
'A5011027'...
'A5011029'...
'A5011030'...
'A5020502'...
'A5030506'...
'A5030507'...
'A5030500'...
'A5030509'...
'A5030526'...
'A5030539'...
'A5030538'...
'A5030541'...
'A5030540'...
'A5030543'...
'A5030542'...
'A5030544'...
'A5010500'...
'A4261070'...
'A4261102'...
'A4261103'...
'A4261104'...
'A4261077'...
'A4261072'...
'A4261071'...
'A4261073'...
'A4261074'...
'A4261075'...
'A4261226'...
'A4261227'...
'A4261229'...
'A4261228'...
'A4261231'...
'A4261230'...
'A4261233'...
'A4261232'...
'A4261234'...
'A4261144'...
'A4261139'...
'A4261100'...
'A4261147'...
'A4261149'...
'A5011036'...
'A4260696'...
'A4261029'...
'A4261020'...
'A4261014'...
'A4261007'...
'A5040517'...
'A5040519'...
'A5050513'...
'A5030508'...
'A2391078'...
'A5031021'...
'A5041065'...
'A2391276'...
'A2391277'...
'A2391278'...
'A2391279'...
'A4261789'...
'A4261790'...
'A2391281'...
'A2391280'...
'A4261791'...
'A5051026'...
'A5051027'...
'A5051028'...
'A5051029'...
'A5051030'...
'A5051032'...
'A5051031'...
'A5060502'...
'A5061012'...
'A5061013'...
'A2391261'...
'A2391262'...
'A2391264'...
'A2391263'...
'A2391265'...
'A2391266'...
'A2391267'...
'A2391268'...
'A2391269'...
'A2391271'...
'A2391270'...
'A2391274'...
'A2391272'...
'A2391273'...
'A4261538'...
'A5031022'...
'A5051016'...
'A4261002'...
'A2391282'...
'A4261794'...
'A4261080'...
'A4261795'...
'A4261797'...
'A4261796'...
'A4261798'...
'A4261799'...
'A4261258'...
'A4261260'...
'A2391284'...
'A2391286'...
'A2391287'...
'A2391288'...
'A2391289'...
'A2391283'...
'A2391290'...
'A2391167'...
'A2391291'...
'A5011040'...
'A5011039'...
'A2390538'...
'A5011012'...
'A5011013'...
'A5011016'...
'A5011017'...
};

% sites = {...
%     'A0020101',...
% 'A0021005',...
% 'A0030501',...
% 'A0031007',...
% 'A0040517',...
% 'A0040518',...
% 'A0040520',...
% 'A0040521',...
% 'A0040522',...
% 'A0041003',...
% 'A0041006',...
% 'A0051003',...
% 'A0211001',...
% 'A0211004',...
% 'A2390506',...
% 'A2390512',...
% 'A2390513',...
% 'A2390514',...
% 'A2390515',...
% 'A2390519',...
% 'A2390531',...
% 'A2390534',...
% 'A2390541',...
% 'A2390556',...
% 'A2390567',...
% 'A2390568',...
% 'A2391023',...
% 'A2391061',...
% 'A2391074',...
% 'A2391077',...
% 'A2391081',...
% 'A2391085',...
% 'A2391086',...
% 'A2391087',...
% 'A2391090',...
% 'A2391091',...
% 'A2391094',...
% 'A2391101',...
% 'A2391103',...
% 'A2391125',...
% 'A2391140',...
% 'A2391143',...
% 'A2391146',...
% 'A2391150',...
% 'A2391151',...
% 'A2391153',...
% 'A2391154',...
% 'A2391184',...
% 'A2391188',...
% 'A2391257',...
% 'A2391259',...
% 'A2391260',...
% 'A4260501',...
% 'A4260502',...
% 'A4260503',...
% 'A4260504',...
% 'A4260505',...
% 'A4260506',...
% 'A4260507',...
% 'A4260508',...
% 'A4260510',...
% 'A4260511',...
% 'A4260512',...
% 'A4260513',...
% 'A4260514',...
% 'A4260515',...
% 'A4260516',...
% 'A4260517',...
% 'A4260518',...
% 'A4260519',...
% 'A4260524',...
% 'A4260525',...
% 'A4260527',...
% 'A4260528',...
% 'A4260530',...
% 'A4260533',...
% 'A4260537',...
% 'A4260550',...
% 'A4260554',...
% 'A4260557',...
% 'A4260558',...
% 'A4260573',...
% 'A4260574',...
% 'A4260575',...
% 'A4260576',...
% 'A4260579',...
% 'A4260580',...
% 'A4260593',...
% 'A4260594',...
% 'A4260595',...
% 'A4260600',...
% 'A4260603',...
% 'A4260605',...
% 'A4260630',...
% 'A4260633',...
% 'A4260638',...
% 'A4260639',...
% 'A4260641',...
% 'A4260642',...
% 'A4260644',...
% 'A4260645',...
% 'A4260652',...
% 'A4260663',...
% 'A4260679',...
% 'A4260688',...
% 'A4260702',...
% 'A4260703',...
% 'A4260705',...
% 'A4260902',...
% 'A4260903',...
% 'A4261020',...
% 'A4261022',...
% 'A4261023',...
% 'A4261024',...
% 'A4261025',...
% 'A4261027',...
% 'A4261034',...
% 'A4261036',...
% 'A4261039',...
% 'A4261041',...
% 'A4261042',...
% 'A4261043',...
% 'A4261044',...
% 'A4261045',...
% 'A4261046',...
% 'A4261047',...
% 'A4261048',...
% 'A4261051',...
% 'A4261053',...
% 'A4261055',...
% 'A4261065',...
% 'A4261066',...
% 'A4261091',...
% 'A4261093',...
% 'A4261099',...
% 'A4261101',...
% 'A4261102',...
% 'A4261104',...
% 'A4261106',...
% 'A4261107',...
% 'A4261108',...
% 'A4261109',...
% 'A4261110',...
% 'A4261122',...
% 'A4261123',...
% 'A4261124',...
% 'A4261126',...
% 'A4261128',...
% 'A4261133',...
% 'A4261134',...
% 'A4261135',...
% 'A4261148',...
% 'A4261153',...
% 'A4261155',...
% 'A4261156',...
% 'A4261158',...
% 'A4261159',...
% 'A4261160',...
% 'A4261161',...
% 'A4261162',...
% 'A4261163',...
% 'A4261164',...
% 'A4261165',...
% 'A4261166',...
% 'A4261167',...
% 'A4261168',...
% 'A4261172',...
% 'A4261173',...
% 'A4261204',...
% 'A4261205',...
% 'A4261206',...
% 'A4261207',...
% 'A4261208',...
% 'A4261209',...
% 'A4261219',...
% 'A4261220',...
% 'A4261221',...
% 'A4261222',...
% 'A4261223',...
% 'A4261224',...
% 'A4261225',...
% 'A4261244',...
% 'A4261245',...
% 'A4261246',...
% 'A4261247',...
% 'A4261248',...
% 'A4261255',...
% 'A4261263',...
% 'A4261264',...
% 'A4261265',...
% 'A4261269',...
% 'A5010500',...
% 'A5010503',...
% 'A5011006',...
% 'A5030502',...
% 'A5030503',...
% 'A5030504',...
% 'A5030525',...
% 'A5030526',...
% 'A5030529',...
% 'A5030532',...
% 'A5030533',...
% 'A5030537',...
% 'A5030543',...
% 'A5031001',...
% 'A5031004',...
% 'A5031005',...
% 'A5031009',...
% 'A5040503',...
% 'A5040512',...
% 'A5040529',...
% 'A5040549',...
% 'A5040552',...
% 'A5040558',...
% 'A5040559',...
% 'A5040563',...
% 'A5040578',...
% 'A5040583',...
% 'A5040901',...
% 'A5041003',...
% 'A5041006',...
% 'A5041014',...
% 'A5041021',...
% 'A5041023',...
% 'A5041045',...
% 'A5041046',...
% 'A5041051',...
% 'A5041052',...
% 'A5050502',...
% 'A5050503',...
% 'A5050510',...
% 'A5050517',...
% 'A5050532',...
% 'A5050533',...
% 'A5050535',...
% 'A5050537',...
% 'A5050543',...
% 'A5051003',...
% 'A5051004',...
% 'A5051016',...
% 'A5060500',...
% 'A5061008',...
% 'A5061009',...
% 'A5061010',...
% 'A5070500',...
% 'A5070501',...
% 'A5070503',...
% 'A5070507',...
% 'A5070901',...
% 'A5071002',...
% 'A5071005',...
% 'A5090502',...
% 'A5090503',...
% 'A5090505',...
% 'A5091002',...
% 'A5091003',...
% 'A5100500',...
% 'A5100512',...
% 'A5100514',...
% 'A5100515',...
% 'A5100516',...
% 'A5120500',...
% 'A5120503',...
% 'A5121002',...
% 'A5121003',...
% 'A5121004',...
% 'A5121005',...
% 'A5121007',...
% 'A5121008',...
% 'A5130501',...
% 'A5131002',...
% 'A5131007',...
% 'A5131014',...
% 'A5131015',...
% 'A4261002',...
% 'A4260572',...
% };

end

%save sdata.mat sdata -mat;