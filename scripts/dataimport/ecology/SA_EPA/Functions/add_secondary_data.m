function lowerlakes = add_secondary_data(lowerlakes,datearray)
sites = fieldnames(lowerlakes);

for i = 1:length(sites)
    
    if isfield(lowerlakes.(sites{i}),'Flow_m3') & ~isfield(lowerlakes.(sites{i}),'Flow_m3_Calc') & ~isfield(lowerlakes.(sites{i}),'Flow') & ~isfield(lowerlakes.(sites{i}),'FLOW')
        lowerlakes.(sites{i}).FLOW = lowerlakes.(sites{i}).Flow_m3;
        lowerlakes.(sites{i}).FLOW.Data(isnan(lowerlakes.(sites{i}).FLOW.Data)) = 0;
    end
    
    if isfield(lowerlakes.(sites{i}),'Flow_m3_Calc')
        lowerlakes.(sites{i}).FLOW = lowerlakes.(sites{i}).Flow_m3_Calc;
        lowerlakes.(sites{i}).FLOW.Data(isnan(lowerlakes.(sites{i}).FLOW.Data)) = 0;
    end
    
    
    if isfield(lowerlakes.(sites{i}),'WQ_DIAG_TOT_TN') & isfield(lowerlakes.(sites{i}),'WQ_NIT_AMM') ...
            & isfield(lowerlakes.(sites{i}),'WQ_NIT_NIT') & ~isfield(lowerlakes.(sites{i}),'WQ_OGM_DON')
        
        TN = create_interpolated_dataset(lowerlakes,'WQ_DIAG_TOT_TN',sites{i},'Surface',datearray);
        disp(sites{i});
        Amm = create_interpolated_dataset(lowerlakes,'WQ_NIT_AMM',sites{i},'Surface',datearray);
        Nit = create_interpolated_dataset(lowerlakes,'WQ_NIT_NIT',sites{i},'Surface',datearray);
        
        if ~isempty(TN) & ~isempty(Amm) & ~isempty(Nit)
            
            lowerlakes.(sites{i}).WQ_OGM_DON = lowerlakes.(sites{i}).WQ_NIT_AMM;
            lowerlakes.(sites{i}).WQ_OGM_DON.Data = (TN - Amm - Nit) * 0.5;
            
            lowerlakes.(sites{i}).WQ_OGM_DON.Date = datearray;
            lowerlakes.(sites{i}).WQ_OGM_DON.Depth(1:length(datearray),1) = 0;
            
            
            lowerlakes.(sites{i}).WQ_OGM_DON = clip_interped_data(lowerlakes.(sites{i}).WQ_OGM_DON,...
                lowerlakes.(sites{i}).WQ_DIAG_TOT_TN);
            
            
            
            clear TN Amm Nit;
        end
        
    end
    
    
    if isfield(lowerlakes.(sites{i}),'WQ_DIAG_TOT_TN') & isfield(lowerlakes.(sites{i}),'WQ_NIT_AMM') ...
            & isfield(lowerlakes.(sites{i}),'WQ_NIT_NIT') & isfield(lowerlakes.(sites{i}),'WQ_OGM_DON') ...
            & ~isfield(lowerlakes.(sites{i}),'WQ_OGM_PON')
        disp([sites{i},':  WQ_OGM_PON']);
        
        
        TN = create_interpolated_dataset(lowerlakes,'WQ_DIAG_TOT_TN',sites{i},'Surface',datearray);
        Amm = create_interpolated_dataset(lowerlakes,'WQ_NIT_AMM',sites{i},'Surface',datearray);
        Nit = create_interpolated_dataset(lowerlakes,'WQ_NIT_NIT',sites{i},'Surface',datearray);
        DON = create_interpolated_dataset(lowerlakes,'WQ_OGM_DON',sites{i},'Surface',datearray);
        
        
        if ~isempty(TN) & ~isempty(Amm) & ~isempty(Nit) & ~isempty(DON)
            
            lowerlakes.(sites{i}).WQ_OGM_PON = lowerlakes.(sites{i}).WQ_OGM_DON;
            lowerlakes.(sites{i}).WQ_OGM_PON.Data = TN - Amm - Nit - DON;
            
            lowerlakes.(sites{i}).WQ_OGM_PON.Date = datearray;
            lowerlakes.(sites{i}).WQ_OGM_PON.Depth(1:length(datearray),1) = 0;
            
            
             lowerlakes.(sites{i}).WQ_OGM_PON = clip_interped_data(lowerlakes.(sites{i}).WQ_OGM_PON,...
                lowerlakes.(sites{i}).WQ_DIAG_TOT_TN);
            
            
            clear TN Amm Nit DON;
        end
    end
    
    if ~isfield(lowerlakes.(sites{i}),'WQ_DIAG_TOT_TN') & ~isfield(lowerlakes.(sites{i}),'WQ_NIT_AMM') & isfield(lowerlakes.(sites{i}),'WQ_DIAG_TOT_TKN') & ~isfield(lowerlakes.(sites{i}),'WQ_OGM_DON') & ~isfield(lowerlakes.(sites{i}),'WQ_OGM_PON')
        disp([sites{i},':  WQ_OGM_PON']);
        
        
        TKN = create_interpolated_dataset(lowerlakes,'WQ_DIAG_TOT_TKN',sites{i},'Surface',datearray);
 %       Amm = create_interpolated_dataset(lowerlakes,'WQ_NIT_AMM',sites{i},'Surface',datearray);
%         Nit = create_interpolated_dataset(lowerlakes,'WQ_NIT_NIT',sites{i},'Surface',datearray);
%         DON = create_interpolated_dataset(lowerlakes,'WQ_OGM_DON',sites{i},'Surface',datearray);
%         
        
        if ~isempty(TKN) %& ~isempty(Amm) %& ~isempty(Nit) & ~isempty(DON)
            
            ON = TKN;
            
            lowerlakes.(sites{i}).WQ_OGM_PON = lowerlakes.(sites{i}).WQ_DIAG_TOT_TKN;
            lowerlakes.(sites{i}).WQ_OGM_PON.Data = ON/2;
            
            lowerlakes.(sites{i}).WQ_OGM_PON.Date = datearray;
            lowerlakes.(sites{i}).WQ_OGM_PON.Depth(1:length(datearray),1) = 0;
            
            lowerlakes.(sites{i}).WQ_OGM_DON = lowerlakes.(sites{i}).WQ_DIAG_TOT_TKN;
            lowerlakes.(sites{i}).WQ_OGM_DON.Data = ON/2;
            
            lowerlakes.(sites{i}).WQ_OGM_DON.Date = datearray;
            lowerlakes.(sites{i}).WQ_OGM_DON.Depth(1:length(datearray),1) = 0;
            
            clear TN Amm Nit DON;
            

            
            
            
        end
    end
    
    if isfield(lowerlakes.(sites{i}),'WQ_OGM_DOC') & ~isfield(lowerlakes.(sites{i}),'WQ_OGM_POC') & ~isfield(lowerlakes.(sites{i}),'WQ_DIAG_TOT_TOC')
        
        disp([sites{i},':  WQ_OGM_POC']);
        
        
        DOC = create_interpolated_dataset(lowerlakes,'WQ_OGM_DOC',sites{i},'Surface',datearray);
        
        
        if ~isempty(DOC)
            
            lowerlakes.(sites{i}).WQ_OGM_POC = lowerlakes.(sites{i}).WQ_OGM_DOC;
            
%             lowerlakes.(sites{i}).WQ_OGM_POC.Data = DOC;
%             lowerlakes.(sites{i}).WQ_OGM_POC.Date = datearray;
%             lowerlakes.(sites{i}).WQ_OGM_POC.Depth(1:length(datearray),1) = 0;
%             
%                        lowerlakes.(sites{i}).WQ_OGM_POC = clip_interped_data(lowerlakes.(sites{i}).WQ_OGM_POC,...
%                 lowerlakes.(sites{i}).WQ_OGM_DOC);  
            
            
            
            clear DOC;
        end
    end
 
    if isfield(lowerlakes.(sites{i}),'WQ_OGM_DOC') & ~isfield(lowerlakes.(sites{i}),'WQ_OGM_POC') & isfield(lowerlakes.(sites{i}),'WQ_DIAG_TOT_TOC')
        
        disp([sites{i},':  WQ_OGM_POC']);
        
        
        DOC = create_interpolated_dataset(lowerlakes,'WQ_OGM_DOC',sites{i},'Surface',datearray);
        TOC = create_interpolated_dataset(lowerlakes,'WQ_DIAG_TOT_TOC',sites{i},'Surface',datearray);
        
        
        
        
        
        if ~isempty(DOC)
            
            lowerlakes.(sites{i}).WQ_OGM_POC = lowerlakes.(sites{i}).WQ_OGM_DOC;
            
            lowerlakes.(sites{i}).WQ_OGM_POC.Data = TOC - DOC;
            lowerlakes.(sites{i}).WQ_OGM_POC.Date = datearray;
            lowerlakes.(sites{i}).WQ_OGM_POC.Depth(1:length(datearray),1) = 0;
            
            lowerlakes.(sites{i}).WQ_OGM_POC = clip_interped_data(lowerlakes.(sites{i}).WQ_OGM_POC,...
                lowerlakes.(sites{i}).WQ_OGM_DOC);  
            
            lowerlakes.(sites{i}).WQ_OGM_DOC
            lowerlakes.(sites{i}).WQ_OGM_POC
            
            
            clear DOC TOC;
        end
    end
    
    
    
    if isfield(lowerlakes.(sites{i}),'WQ_PHS_FRP')
        
        disp([sites{i},':  WQ_PHS_FRP_ADS']);
        lowerlakes.(sites{i}).WQ_PHS_FRP_ADS = lowerlakes.(sites{i}).WQ_PHS_FRP;
            
        lowerlakes.(sites{i}).WQ_PHS_FRP_ADS.Data = lowerlakes.(sites{i}).WQ_PHS_FRP.Data .* 0.1;
        
        
%         
%         
%         WQ_PHS_FRP = create_interpolated_dataset(lowerlakes,'WQ_PHS_FRP',sites{i},'Surface',datearray);
%         
%         
%         if ~isempty(WQ_PHS_FRP)
%             
%             lowerlakes.(sites{i}).WQ_PHS_FRP_ADS = lowerlakes.(sites{i}).WQ_PHS_FRP;
%             
%             lowerlakes.(sites{i}).WQ_PHS_FRP_ADS.Data = WQ_PHS_FRP .* 0.1;
%             lowerlakes.(sites{i}).WQ_PHS_FRP_ADS.Date = datearray;
%             lowerlakes.(sites{i}).WQ_PHS_FRP_ADS.Depth(1:length(datearray),1) = 0;
%             
%             lowerlakes.(sites{i}).WQ_PHS_FRP_ADS = clip_interped_data(lowerlakes.(sites{i}).WQ_PHS_FRP_ADS,...
%                 lowerlakes.(sites{i}).WQ_PHS_FRP);
%             
%             
%             
%             clear WQ_PHS_FRP;
%         end
    end
    
    if isfield(lowerlakes.(sites{i}),'WQ_DIAG_TOT_TP') & isfield(lowerlakes.(sites{i}),'WQ_PHS_FRP') & isfield(lowerlakes.(sites{i}),'WQ_PHS_FRP_ADS')
        
        disp([sites{i},':  WQ_OGM_DOP']);
        
        TP = create_interpolated_dataset(lowerlakes,'WQ_DIAG_TOT_TP',sites{i},'Surface',datearray);
        FRP = create_interpolated_dataset(lowerlakes,'WQ_PHS_FRP',sites{i},'Surface',datearray);
        FRP_ADS = create_interpolated_dataset(lowerlakes,'WQ_PHS_FRP_ADS',sites{i},'Surface',datearray);
        
        if ~isempty(TP) & ~isempty(FRP)& ~isempty(FRP_ADS)
            
            
            lowerlakes.(sites{i}).WQ_OGM_DOP = lowerlakes.(sites{i}).WQ_PHS_FRP;
            lowerlakes.(sites{i}).WQ_OGM_DOP.Data = (TP-FRP-FRP_ADS).* 0.4;
            
            lowerlakes.(sites{i}).WQ_OGM_DOP.Date = datearray;
            lowerlakes.(sites{i}).WQ_OGM_DOP.Depth(1:length(datearray),1) = 0;
            
            
                        lowerlakes.(sites{i}).WQ_OGM_DOP = clip_interped_data(lowerlakes.(sites{i}).WQ_OGM_DOP,...
                lowerlakes.(sites{i}).WQ_DIAG_TOT_TP);
            
            clear TP FRP FRP_ADS;
        end
        
    end
    
    if isfield(lowerlakes.(sites{i}),'WQ_DIAG_TOT_TP') & isfield(lowerlakes.(sites{i}),'WQ_PHS_FRP') & isfield(lowerlakes.(sites{i}),'WQ_PHS_FRP_ADS')
        
        disp([sites{i},':  WQ_OGM_POP']);
        
        
        TP = create_interpolated_dataset(lowerlakes,'WQ_DIAG_TOT_TP',sites{i},'Surface',datearray);
        FRP = create_interpolated_dataset(lowerlakes,'WQ_PHS_FRP',sites{i},'Surface',datearray);
        FRP_ADS = create_interpolated_dataset(lowerlakes,'WQ_PHS_FRP_ADS',sites{i},'Surface',datearray);
        if ~isempty(TP) & ~isempty(FRP)& ~isempty(FRP_ADS)
            
            lowerlakes.(sites{i}).WQ_OGM_POP = lowerlakes.(sites{i}).WQ_PHS_FRP;
            lowerlakes.(sites{i}).WQ_OGM_POP.Data = (TP-FRP-FRP_ADS).* 0.5;
            
            lowerlakes.(sites{i}).WQ_OGM_POP.Date = datearray;
            lowerlakes.(sites{i}).WQ_OGM_POP.Depth(1:length(datearray),1) = 0;
            
                                    lowerlakes.(sites{i}).WQ_OGM_POP = clip_interped_data(lowerlakes.(sites{i}).WQ_OGM_POP,...
                lowerlakes.(sites{i}).WQ_DIAG_TOT_TP);
            
            
            clear TP FRP FRP_ADS;
        end
    end
    
%     if isfield(lowerlakes.(sites{i}),'WQ_DIAG_TOT_TP') & isfield(lowerlakes.(sites{i}),'WQ_PHS_FRP') & isfield(lowerlakes.(sites{i}),'WQ_PHS_FRP_ADS')
%         
%         disp([sites{i},':  WQ_OGM_POP']);
%         
%         TP = create_interpolated_dataset(lowerlakes,'WQ_DIAG_TOT_TP',sites{i},'Surface',datearray);
%         FRP = create_interpolated_dataset(lowerlakes,'WQ_PHS_FRP',sites{i},'Surface',datearray);
%         FRP_ADS = create_interpolated_dataset(lowerlakes,'WQ_PHS_FRP_ADS',sites{i},'Surface',datearray);
%         if ~isempty(TP) & ~isempty(FRP)& ~isempty(FRP_ADS)
%             
%             lowerlakes.(sites{i}).WQ_OGM_POP = lowerlakes.(sites{i}).WQ_PHS_FRP;
%             lowerlakes.(sites{i}).WQ_OGM_POP.Data = (TP-FRP-FRP_ADS).* 0.5;
%             
%             lowerlakes.(sites{i}).WQ_OGM_POP.Date = datearray;
%             lowerlakes.(sites{i}).WQ_OGM_POP.Depth(1:length(datearray),1) = 0;
%             clear TP FRP FRP_ADS;
%         end
%     end
    
    if isfield(lowerlakes.(sites{i}),'WQ_PHY_GRN') & ~isfield(lowerlakes.(sites{i}),'WQ_DIAG_PHY_TCHLA')
        
        disp([sites{i},':  WQ_PHY_GRN']);
        
        lowerlakes.(sites{i}).WQ_DIAG_PHY_TCHLA = lowerlakes.(sites{i}).WQ_PHY_GRN;
        lowerlakes.(sites{i}).WQ_DIAG_PHY_TCHLA.Data = lowerlakes.(sites{i}).WQ_PHY_GRN.Data ./ 4.166667;
        
    end
    
    if isfield(lowerlakes.(sites{i}),'WQ_DIAG_TOT_TOC') & ~isfield(lowerlakes.(sites{i}),'WQ_OGM_DOC') ...
            & ~isfield(lowerlakes.(sites{i}),'WQ_OGM_POC')
        
        disp([sites{i},':  WQ_OGM_DOC']);
        
        lowerlakes.(sites{i}).WQ_OGM_DOC = lowerlakes.(sites{i}).WQ_DIAG_TOT_TOC;
        lowerlakes.(sites{i}).WQ_OGM_DOC.Data = lowerlakes.(sites{i}).WQ_DIAG_TOT_TOC.Data ./ 2;
        
    end
    if isfield(lowerlakes.(sites{i}),'WQ_DIAG_TOT_TOC') & ~isfield(lowerlakes.(sites{i}),'WQ_OGM_POC') ...
            & ~isfield(lowerlakes.(sites{i}),'WQ_OGM_DOC')
        
        disp([sites{i},':  WQ_OGM_POC']);
        
        lowerlakes.(sites{i}).WQ_OGM_POC = lowerlakes.(sites{i}).WQ_DIAG_TOT_TOC;
        lowerlakes.(sites{i}).WQ_OGM_POC.Data = lowerlakes.(sites{i}).WQ_DIAG_TOT_TOC.Data ./ 2;
        
    end    
    
    
    if ~isfield(lowerlakes.(sites{i}),'WQ_PHY_GRN') & isfield(lowerlakes.(sites{i}),'WQ_DIAG_PHY_TCHLA')
        
        disp([sites{i},':  WQ_DIAG_PHY_TCHLA']);
        
        lowerlakes.(sites{i}).WQ_PHY_GRN = lowerlakes.(sites{i}).WQ_DIAG_PHY_TCHLA;
        lowerlakes.(sites{i}).WQ_PHY_GRN.Data = lowerlakes.(sites{i}).WQ_DIAG_PHY_TCHLA.Data .* 4.166667;
        
    end
    
    %     if isfield(lowerlakes.(sites{i}),'WQ_PHY_GRN') & isfield(lowerlakes.(sites{i}),'ALGAL_TOTAL')
    %
    %         disp([sites{i},':  ALGAL_TOTAL']);
    %
    %         %lowerlakes.(sites{i}).WQ_PHY_GRN = lowerlakes.(sites{i}).WQ_DIAG_PHY_TCHLA;
    %         lowerlakes.(sites{i}).WQ_PHY_GRN.Data = [lowerlakes.(sites{i}).WQ_PHY_GRN.Data;lowerlakes.(sites{i}).ALGAL_TOTAL.Data .* 4.166667];
    %         lowerlakes.(sites{i}).WQ_PHY_GRN.Date = [lowerlakes.(sites{i}).WQ_PHY_GRN.Date;lowerlakes.(sites{i}).ALGAL_TOTAL.Date];
    %         lowerlakes.(sites{i}).WQ_PHY_GRN.Depth = [];
    %         lowerlakes.(sites{i}).WQ_PHY_GRN.Depth(1:length(lowerlakes.(sites{i}).WQ_PHY_GRN.Data),1) = 0;
    %
    %         [lowerlakes.(sites{i}).WQ_PHY_GRN.Date,ind] = sort(lowerlakes.(sites{i}).WQ_PHY_GRN.Date);
    %         lowerlakes.(sites{i}).WQ_PHY_GRN.Data = lowerlakes.(sites{i}).WQ_PHY_GRN.Data(ind);
    %
    %     end
    
    
    
    
    if isfield(lowerlakes.(sites{i}),'WQ_DIAG_TOT_TURBIDITY') & ~isfield(lowerlakes.(sites{i}),'WQ_DIAG_TOT_TSS')
        
        disp([sites{i},':  WQ_DIAG_TOT_TSS']);
        
        lowerlakes.(sites{i}).WQ_DIAG_TOT_TSS = lowerlakes.(sites{i}).WQ_DIAG_TOT_TURBIDITY;
        
        % TURB = 0.43.*TSS + 9.2
        
        lowerlakes.(sites{i}).WQ_DIAG_TOT_TSS.Data = 0.43 .* lowerlakes.(sites{i}).WQ_DIAG_TOT_TURBIDITY.Data   +  9.2;
        
    end
    
    if isfield(lowerlakes.(sites{i}),'WQ_DIAG_TOT_TURBIDITY')
        
        disp([sites{i},':  WQ_TRC_SS1']);
        
        lowerlakes.(sites{i}).WQ_TRC_SS1 = lowerlakes.(sites{i}).WQ_DIAG_TOT_TURBIDITY;
        
        % TURB = 0.43.*TSS + 9.2
        
        lowerlakes.(sites{i}).WQ_TRC_SS1.Data = 0.43 .* lowerlakes.(sites{i}).WQ_DIAG_TOT_TURBIDITY.Data   +  9.2;
        
    end
    
    
    
    
    
    
    
    
    
    
    
    if isfield(lowerlakes.(sites{i}),'WQ_DIAG_TOT_TKN') & ...
            isfield(lowerlakes.(sites{i}),'WQ_NIT_AMM')
        
        
        % First variable
        Fdate = lowerlakes.(sites{i}).WQ_DIAG_TOT_TKN.Date;
        Fdata = lowerlakes.(sites{i}).WQ_DIAG_TOT_TKN.Data;
        % Second Variable
        Sdate = lowerlakes.(sites{i}).WQ_NIT_AMM.Date;
        Sdata = lowerlakes.(sites{i}).WQ_NIT_AMM.Data;
        % Third Variable
        
        
        xdate = [min(Fdate):1:max(Fdate)]';
        
        if length(~isnan(Fdata)) > 3
            
            FIdata = interp1(Fdate(~isnan(Fdata)),Fdata(~isnan(Fdata)),xdate,'linear',mean(Fdata(~isnan(Fdata))));
            
            SIdata = interp1(Sdate(~isnan(Sdata)),Sdata(~isnan(Sdata)),xdate,'linear',mean(Sdata(~isnan(Sdata))));
            
            
            
            
            
            temp_val = FIdata - SIdata;
            
            % Set the variable
            lowerlakes.(sites{i}).ON = lowerlakes.(sites{i}).WQ_DIAG_TOT_TKN;
            
            lowerlakes.(sites{i}).ON.Data = [];
            lowerlakes.(sites{i}).ON.Depth = [];
            lowerlakes.(sites{i}).ON.Date=[];
            
            for ii = 1:length(Fdate)
                ss = find(floor(xdate) == floor(Fdate(ii)));
                if ~isempty(ss)
                    lowerlakes.(sites{i}).ON.Data(ii,1) = temp_val(ss);
                    lowerlakes.(sites{i}).ON.Date(ii,1) = xdate(ss);
                    lowerlakes.(sites{i}).ON.Depth(ii,1) = 0;
                end
            end
            lowerlakes.(sites{i}).ON.Title = {'Organic Nitrogen'};
        end
        clear Fdate Fdata Sdate Sdata SIdata FIdata temp_val;
        
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    if isfield(lowerlakes.(sites{i}),'WQ_DIAG_TOT_TP') & ...
            isfield(lowerlakes.(sites{i}),'WQ_PHS_FRP')
        
        
        % First variable
        Fdate = lowerlakes.(sites{i}).WQ_DIAG_TOT_TP.Date;
        Fdata = lowerlakes.(sites{i}).WQ_DIAG_TOT_TP.Data;
        % Second Variable
        Sdate = lowerlakes.(sites{i}).WQ_PHS_FRP.Date;
        Sdata = lowerlakes.(sites{i}).WQ_PHS_FRP.Data;
        % Third Variable
        
        
        xdate = [min(floor(Fdate)):1:max(floor(Fdate))]';
        
        if length(~isnan(Fdata)) > 3
            
            FIdata = interp1(Fdate,Fdata,xdate,'linear',mean(Fdata));
            
            SIdata = interp1(Sdate(~isnan(Sdata)),Sdata(~isnan(Sdata)),xdate,'linear',mean(Sdata(~isnan(Sdata))));
            
            
            
            
            
            temp_val = FIdata - SIdata;
            
            % Set the variable
            lowerlakes.(sites{i}).OP = lowerlakes.(sites{i}).WQ_DIAG_TOT_TP;
            
            lowerlakes.(sites{i}).OP.Data = [];
            lowerlakes.(sites{i}).OP.Depth = [];
            lowerlakes.(sites{i}).OP.Date=[];
            
            for ii = 1:length(Fdate)
                ss = find(floor(xdate) == floor(Fdate(ii)));
                if ~isempty(ss)
                    lowerlakes.(sites{i}).OP.Data(ii,1) = temp_val(ss);
                    lowerlakes.(sites{i}).OP.Date(ii,1) = xdate(ss);
                    lowerlakes.(sites{i}).OP.Depth(ii,1) = 0;
                end
            end
            lowerlakes.(sites{i}).OP.Title = {'Organic Phosphorus'};
        end
        clear Fdate Fdata Sdate Sdata SIdata FIdata temp_val;
        
    end
    
    if isfield(lowerlakes.(sites{i}),'Conductivity')
        
        disp([sites{i},':  SAL']);
        lowerlakes.(sites{i}).SAL = lowerlakes.(sites{i}).Conductivity;
        
        lowerlakes.(sites{i}).SAL.Data = [];
        
        lowerlakes.(sites{i}).SAL.Data = conductivity2salinity(lowerlakes.(sites{i}).Conductivity.Data);
        
        lowerlakes.(sites{i}).SAL.Title = {'Salinity'};
    end
    
    
    if isfield(lowerlakes.(sites{i}),'WQ_TRC_SS1')
        
        disp([sites{i},':  SS1']);
        lowerlakes.(sites{i}).WQ_NCS_SS1 = lowerlakes.(sites{i}).WQ_TRC_SS1;
        
    end
     if isfield(lowerlakes.(sites{i}),'WQ_TRC_SS2')
        
        disp([sites{i},':  SS2']);
        lowerlakes.(sites{i}).WQ_NCS_SS2 = lowerlakes.(sites{i}).WQ_TRC_SS2;
        
    end   
    
    
    
    %     if isfield(lowerlakes.(sites{i}),'WQ_DIAG_PHY_TCHLA')
    %         lowerlakes.(sites{i}).WQ_PHY_BGA = lowerlakes.(sites{i}).WQ_DIAG_PHY_TCHLA;
    %         lowerlakes.(sites{i}).WQ_PHY_BGA.Data = lowerlakes.(sites{i}).WQ_DIAG_PHY_TCHLA.Data * 0.3;
    %
    %         lowerlakes.(sites{i}).WQ_PHY_FDIAT = lowerlakes.(sites{i}).WQ_DIAG_PHY_TCHLA;
    %         lowerlakes.(sites{i}).WQ_PHY_FDIAT.Data = lowerlakes.(sites{i}).WQ_DIAG_PHY_TCHLA.Data * 0.3;
    %
    %         lowerlakes.(sites{i}).WQ_PHY_MDIAT = lowerlakes.(sites{i}).WQ_DIAG_PHY_TCHLA;
    %         lowerlakes.(sites{i}).WQ_PHY_MDIAT.Data = lowerlakes.(sites{i}).WQ_DIAG_PHY_TCHLA.Data * 0;
    %
    %         lowerlakes.(sites{i}).WQ_PHY_KARLO = lowerlakes.(sites{i}).WQ_DIAG_PHY_TCHLA;
    %         lowerlakes.(sites{i}).WQ_PHY_KARLO.Data = lowerlakes.(sites{i}).WQ_DIAG_PHY_TCHLA.Data * 0.1;
    %
    %
    %         if ~isfield(lowerlakes.(sites{i}),'WQ_PHY_GRN')
    %                     lowerlakes.(sites{i}).WQ_PHY_GRN = lowerlakes.(sites{i}).WQ_DIAG_PHY_TCHLA;
    %                     lowerlakes.(sites{i}).WQ_PHY_GRN.Data = lowerlakes.(sites{i}).WQ_DIAG_PHY_TCHLA.Data * 0.3;
    %         end
    %     end
    
end


% Remove zero values.

for i = 1:length(sites)
    
    vars = fieldnames(lowerlakes.(sites{i}));
    
    for j = 1:length(vars)
                
        sss = find(lowerlakes.(sites{i}).(vars{j}).Data > 0);
        if ~isempty(sss)
            if strcmpi(vars{j},'H') == 0 &  strcmpi(vars{j},'Tide') == 0 & strcmpi(vars{j},'FLOW')==0 & strcmpi(vars{j},'SAL')==0
                
                tdate = lowerlakes.(sites{i}).(vars{j}).Date(sss);
                tdata = lowerlakes.(sites{i}).(vars{j}).Data(sss);
                
                lowerlakes.(sites{i}).(vars{j}).Date = [];
                lowerlakes.(sites{i}).(vars{j}).Data =[];
                lowerlakes.(sites{i}).(vars{j}).Depth = [];
                
                lowerlakes.(sites{i}).(vars{j}).Date = tdate;
                lowerlakes.(sites{i}).(vars{j}).Data = tdata;
                lowerlakes.(sites{i}).(vars{j}).Depth(1:length(sss),1) = 0;
            end
        end
    end
end

%lowerlakes.SAW_Blanchetown_Raw = rmfield(lowerlakes.SAW_Blanchetown_Raw,'TEMP');























