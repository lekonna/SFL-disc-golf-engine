alter table kisakonetesti_Classification add MinimumRating INT DEFAULT 0 AFTER MaximumAge;
alter table kisakonetesti_Classification add MaximumRating INT DEFAULT 0 AFTER MinimumRating;
alter table kisakonetesti_Classification add PdgaStatusRequirement CHAR(1) AFTER MaximumRating;
alter table kisakonetesti_Classification modify GenderRequirement CHAR(1) AFTER Name;
