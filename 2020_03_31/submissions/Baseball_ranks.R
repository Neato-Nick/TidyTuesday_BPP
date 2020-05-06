#Load packages
library(Lahman)
library(tidyverse)
library(purrr)
library(dplyr)
library(tidyr)



data(Teams)
data(Salaries)


## Payroll for each team for each year
### Salary is the amount of money each player is paid in a season
### Payroll is the mean of Salary

#Data from 1900 and after
TeamSalaries<- Salaries%>%  
  filter(Salaries$yearID>= 1900)%>% #split data by teams
  split(.$teamID)%>% #Group data by season and team
  map(group_by, yearID, teamID)%>% 
  map(summarise, payroll = mean(salary)) #Payroll- yearly mean team salary 

#Take list data and reduce back into a dataframe
TeamPayroll.df<- Reduce(rbind, TeamSalaries)
#Order by year and team name
TeamPayroll.df<- TeamPayroll.df[order(TeamPayroll.df$yearID, TeamPayroll.df$teamID),]
#Filter data to match that of the salary data (only covers 1985-2016)
TeamWins<- Teams%>%
  filter(yearID>=1985)%>%
  filter(yearID<=2016)
#Add the payroll data to the Team statistics dataframe
TeamWins$payroll<- as.numeric(TeamPayroll.df$payroll)

#Play with Rank
TeamWins <- TeamWins %>%
  group_by(yearID, lgID) %>%
  mutate(pay_rank=rank(payroll, ties.method = "min"))

TeamWins <- TeamWins %>%
  group_by(yearID, lgID) %>%
  mutate(w_rank=rank(W, ties.method = "min"))

ggplot(TeamWins, aes(x=pay_rank, y=w_rank, color = divID))+geom_point()+
  xlab("Pay Rank low to high")+
  ylab("Win Rank low to high")+
  ggtitle("Rank")
#Lets fix this by Wins/ Games
TeamWins$avg_wins <- (TeamWins$W/ TeamWins$G)

####semi parametric...
ggplot(TeamWins, aes(x=pay_rank, y=avg_wins, color = teamID))+geom_point()+
  xlab("Pay Rank low to high")+
  ylab("Win Rank low to high")+
  ggtitle("Rank")

ggplot(TeamWins, aes(x=pay_rank, y=avg_wins))+
  geom_point()+
  facet_wrap(.~yearID)+
  geom_smooth(se = FALSE, size = 1.5, method = lm) +
  theme_bw()+
  xlab("Pay Normalize by mean")+
  ylab("Percent Wins")

ranks <- c(1, 2, 2, 3, 4)
rank(ranks) # [1] 1.0 2.5 2.5 4.0 5.0
rank(ranks, ties.method = "max") #[1] 1 3 3 4 5
rank(ranks, ties.method = "min") #[1] 1 2 2 4 5
rank(ranks, ties.method = "first") #[1] 1 2 2 4 5
rank(ranks, ties.method = "last") #[1] 1 2 2 4 5

TeamWins %>% 
  as.tibble() %>% 
  count(w_rank)

TeamWins %>% 
  as.tibble() %>% 
  count(pay_rank)

TeamWins %>% 
  as.tibble() %>% 
  count(lgID)

teams <- TeamWins %>% 
  as.tibble() %>% 
  count(teamID)

test4 <- TeamWins[TeamWins$teamID != "MIA" & 
                    TeamWins$teamID != "ANA" &
                    TeamWins$teamID != "CAL" & 
                    TeamWins$teamID != "LAA" &
                    TeamWins$teamID !="WAS" &
                    TeamWins$teamID !="ML4" & 
                    TeamWins$teamID !="ARI" &
                    TeamWins$teamID !="FLO" & 
                    TeamWins$teamID !="MIL" & 
                    TeamWins$teamID !="TBA" & 
                    TeamWins$teamID !="MON" &
                    TeamWins$teamID != "COL",]
#just check to make sure equal teams 
teams <- test4 %>% 
  as.tibble() %>% 
  count(teamID)
#will have to do something with leagues 
teams <- test4 %>% 
  as.tibble() %>% 
  count(lgID)

#Play with Rank
test4 <- test4 %>%
  group_by(yearID, lgID) %>%
  mutate(pay_rank=rank(payroll, ties.method = "min"))

test4 <- test4 %>%
  group_by(yearID, lgID) %>%
  mutate(w_rank=rank(W, ties.method = "min"))

test5 <- test4[test4$lgID != "AL",]
ggplot(test5, aes(x=pay_rank, y=w_rank, color = lgID))+geom_point()+
  xlab("Pay Rank low to high")+
  ylab("Win Rank low to high")+
  ggtitle("Rank")

ggplot(test5, aes(x=pay_rank, y=w_rank))+
  geom_point()+
  facet_wrap(.~yearID)+
  geom_smooth(se = FALSE, size = 1.5, method = lm) +
  theme_bw()+
  xlab("Pay Normalize by mean")+
  ylab("Percent Wins")

  
p <- c(0.25, 0.5, 0.75)
p_names <- map_chr(p, ~paste0(.x*100, "%"))
p_funs <- map(p, ~partial(quantile, probs = .x, na.rm = TRUE)) %>% 
  set_names(nm = p_names)
p_funs

quantiles <- TeamWins %>%
  group_by(yearID, lgID) %>%
  summarize_at(vars(payroll), funs(!!!p_funs))

TeamWins <- inner_join(TeamWins, quantiles, by = c("yearID", "lgID"))

TeamWins$pos_rank[TeamWins$payroll <= TeamWins$`25%`] <- "1"
TeamWins$pos_rank[TeamWins$payroll > TeamWins$`25%` & TeamWins$payroll < TeamWins$med_pay ] <- "2"
TeamWins$pos_rank[TeamWins$payroll >= TeamWins$med_pay & TeamWins$payroll < TeamWins$`75%`] <- "3"
TeamWins$pos_rank[TeamWins$payroll >= TeamWins$`75%`] <- "4"

ggplot(TeamWins, aes(pos_rank, avg_wins, color = lgID))+geom_violin()+
  geom_jitter(width = 0.1, aes(colour = teamID)) +
  xlab("Pay Class")+
  ylab("Percent wins")+
  ggtitle("")   

p <- ggplot(TeamWins, aes(y = avg_wins, x = pos_rank))
p + geom_boxplot()

#within the team
ggplot(TeamPayroll.df, aes(yearID, payroll, color = teamID))+geom_boxplot()+
  geom_jitter(width = 0.1, aes(colour = teamID)) +
  xlab("Pay Class")+
  ylab("Percent wins")+
  ggtitle("")   

ggplot(TeamPayroll.df, aes(y =log(payroll), x = teamID))+
  geom_boxplot(aes(fill = teamID))+
  facet_wrap(.~yearID)+
  theme_bw()+
  xlab("Pay Normalize by mean")+
  ylab("Percent Wins")



  
