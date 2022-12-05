pcod <- read_csv("../../../../P.cod-2022/data/size_data_raw.csv") %>%
  clean_names() %>%
  mutate_at(c("temperature_treatment", "days_post_hatch", "measurement", "tank", "photo_number"), factor) %>%
  mutate(date_collected=as.Date(date_collected, "%m/%d/%Y")) %>% 
  #filter(measurement=="Length") %>%
  left_join(
    read_csv("../../../../P.cod-2022/data/sample_data.csv") %>%
  clean_names() %>%
  mutate_at(c("sample_date", "tank", "photo_number", "treatment", "temperature", "p_h"), factor) %>%
    mutate(date_collected=as.Date(sample_date, "%m/%d/%Y")) %>% 
    dplyr::select(date_collected, tank, temperature, p_h, photo_number, vial), 
  by=c("date_collected", "tank", "photo_number"))

pcod %>% View() #write_clip()

# Define x limits 
min((pcod %>% filter(measurement=="Length"))$value_mm)
max((pcod %>% filter(measurement=="Length"))$value_mm)

# Examine stage-specific size data by temperature and pH 
pcod %>% filter(measurement=="Length") %>% 
  ggplot(aes(x=value_mm, color=p_h, fill=p_h)) + geom_histogram(bins = 25, alpha=0.5, position="dodge") + 
  xlim(4.5, 8) + scale_x_continuous(breaks=seq(4.5,8, 0.5)) + 
  facet_wrap(~temperature, nrow=3) + theme_minimal() + 
  ggtitle("All samples")

pcod %>% 
  group_by(temperature, p_h, measurement) %>%
  summarise(mean=mean(value_mm, na.rm = T), sd=sd(value_mm, na.rm = T), min=min(value_mm), max=max(value_mm)) %>% 
  arrange(measurement, temperature, p_h)

write_csv(pcod, file="../../../../P.cod-2022/data/size_data_annotated.csv", col_names = TRUE)

pcod %>% filter(measurement=="Length") %>% write_clip()
pcod %>% filter(measurement=="Height") %>% write_clip()



# For some reason 5/16 dates are duplicated - why?
pcod %>% filter(measurement=="Length") %>% filter(date_collected == "5/16/22") %>% 
  write_clip()
  

min((pcod %>% filter(measurement=="Length"))$value_mm)
max((pcod %>% filter(measurement=="Length"))$value_mm)
  
# read in and plot sizes selected for RNAseq 
read_csv("../../../../P.cod-2022/data/length_data_rnaseq.csv", na = c("NA", "")) %>%
  clean_names() %>%
  mutate_at(c("temperature", "p_h", "tank"), factor) %>% 
  ggplot(aes(x=value_mm, color=p_h, fill=p_h)) + geom_histogram(bins = 20, alpha=0.5, position="dodge") + 
  #xlim(4.5, 8) + 
  scale_x_continuous(breaks=seq(4.5,8, 0.5)) + 
  facet_wrap(~temperature, nrow=3) + theme_minimal() + 
  ggtitle("RNA-Seq Samples - size spectrum")
  
