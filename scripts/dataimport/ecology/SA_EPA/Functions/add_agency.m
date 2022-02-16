function site = add_agency(site,agency)

vars = fieldnames(site);

for i = 1:length(vars)
    site.(vars{i}).Agency = agency;
end