clear all; close all;

sheet_names = {'Flux rates - MER - base.csv', 'Flux rates - MER - scen1.csv'};

vars = {...
    'SAL',...
    'WQ_NIT_AMM',...
    'WQ_NIT_NIT',...
    'WQ_PHS_FRP',...
    'WQ_SIL_RSI',...
    'WQ_OGM_PON',...
    'WQ_OGM_DON',...
    'WQ_OGM_POP',...
    'WQ_OGM_DOP',...
    'WQ_DIAG_PHY_TCHLA',...
    };

vars2 = {...
    'Salt',...
    'NIT_amm',...
    'NIT_nit',...
    'PHS_frp',...
    'SIL_rsi',...
    'OGM_pon',...
    'OGM_don',...
    'OGM_pop',...
    'OGM_dop',...
    'PHY_grn',...
    };

facs=[1 14/1000 14/1000 31/1000 28.1/1000 14/1000 14/1000 31/1000 31/1000 1];
%__________________________________________________________________________


barrages=2:6;
ocean=18;
south=12;
north=8;

NS=[2 3 4 5 6 8 12 18];
bars={'Goolwa','Boundary','Ewe','Mundoo','Tauwitchere','Coorong_1','Coorong_Parnka_2','Murray'};

% Create the daily time array

for i = 1:length(sheet_names)
    
    if i==1
        load('.\Flux_Base.mat');
        outdir = './Spreadsheets_MER_base/';
    else
        load('.\Flux_scen1.mat');
        outdir = './Spreadsheets_Scen1/';
    end

    for kk=length(NS) %1:length(NS)
 
    if ~exist([outdir,bars{kk},'/'],'dir')
        mkdir([outdir,bars{kk},'/']);
    end
            fid = fopen([outdir,bars{kk},'/',sheet_names{i}],'wt');
        
           
        % Header
        fprintf(fid,'Date,');
        
        for ii = 1:length(vars)
            if ii == length(vars)
                fprintf(fid,'%s\n',vars2{ii});
            else
                fprintf(fid,'%s,',vars2{ii});
            end
        end
        
            
    
    

    
    daily_date = flux.Murray.mDate;
    
    
    
        for j = 1:length(daily_date)
            
            s_date = daily_date(j);
            fprintf(fid,'%s,',datestr(s_date,'dd/mm/yyyy HH:MM:SS'));
            
            for l = 1:length(vars)
                
                s_var = vars2{l};
                
                s_val = flux.(bars{kk}).(s_var)(j);
                s_val = s_val * facs(l);
                
                if l == length(vars)
                    fprintf(fid,'%10.4f\n',s_val);
                else
                    fprintf(fid,'%10.4f,',s_val);
                end
                
            end
        end
    end
end


