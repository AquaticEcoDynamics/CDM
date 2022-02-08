load dew_barrage_2020.mat;

s2020 = barrages; clear barrages;

load dew_barrage.mat;

s2021 = barrages;clear barrages;

load dew_barrage_2021_v2.mat;

s2022 = barrages;clear barrages;

load cewo.mat;

cewo = cewo;clear barrages;


sss = find(s2020.Mundoo.Flow.Date >= datenum(2019,01,01) & ...
    s2020.Mundoo.Flow.Date <= datenum(2020,01,01));

ttt = find(s2021.Mundoo.Flow.Date >= datenum(2019,01,01) & ...
    s2021.Mundoo.Flow.Date <= datenum(2020,01,01));

www = find(s2022.Mundoo.Flow.Date >= datenum(2019,01,01) & ...
    s2022.Mundoo.Flow.Date <= datenum(2020,01,01));

vvv = find(cewo.obs.Mundoo.Flow.Date >= datenum(2019,01,01) & ...
    cewo.obs.Mundoo.Flow.Date <= datenum(2020,01,01));

sum(s2020.Mundoo.Flow.Data(sss) .* 86400)

sum(s2021.Mundoo.Flow.Data(ttt) .* 86400)

sum(s2022.Mundoo.Flow.Data(www) .* 86400)

sum(cewo.obs.Mundoo.Flow.Data(vvv) .* 86400)