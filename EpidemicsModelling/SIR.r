
SIR.onestep <- function (x, params) {
  susceptible <- x[2] # susceptible
  infected <- x[3]  # Infected
  recovered <- x[4]  # Recovered
  N <- susceptible+infected+recovered  # Total number of people in population
  mu <- params["mu"] # recovery rate
  beta <- params["beta"] # trnasmission rate 
  ## each individual rate
  rates <- c(
             #birth=mu*N,
             infection=beta*susceptible*infected/N,
             recovery=mu*infected
             #sdeath=mu*X,
             #ideath=mu*Y,
             #rdeath=mu*Z
             )
  ## what changes with each event?
  transitions <- list( 
                      #birth=c(1,0,0),
                      infection=c(-1,1,0),
                      recovery=c(0,-1,1)
                      #sdeath=c(-1,0,0),
                      #ideath=c(0,-1,0),
                      #rdeath=c(0,0,-1)
                      )
  ## total event rate
  total.rate <- sum(rates)
  ## waiting time
  if (total.rate==0) 
    tau <- Inf
  else
    tau <- rexp(n=1,rate=total.rate)
  ## which event occurs?
  event <- sample.int(n=2,size=1,prob=rates/total.rate)
  x+c(tau,transitions[[event]])
}

SIR.simul <- function (x, params, maxstep = 10000) {
  output <- array(dim=c(maxstep+1,4))
  colnames(output) <- names(x)
  output[1,] <- x
  k <- 1
  ## loop until either k > maxstep or
  ## there are no more infectives
  while ((k <= maxstep) && (x["infected"] > 0)) {
    k <- k+1
    output[k,] <- x <- SIR.onestep(x,params)
  }
  as.data.frame(output[1:k,])
}

set.seed(56856583)
nsims <- 10
xstart <- c(time=0,susceptible=80,infected=20,recovered=0) #initial conditions
params <- c(mu=3,beta=1 ) #model parameters

require(plyr)
simdat <- rdply(
                nsims,
                SIR.simul(xstart,params)
                )
head(simdat)
plot(infected~time,data=simdat,type='n')

d_ply(simdat,".n",function(x)lines(infected~time,data=x,col=.n))

head(simdat)
plot(recovered~time,data=simdat,type='n')

d_ply(simdat,".n",function(x)lines(recovered~time,data=x,col=.n))

head(simdat)
plot(susceptible~time,data=simdat,type='n')

d_ply(simdat,".n",function(x)lines(susceptible~time,data=x,col=.n))

set.seed(56856583)
nsims <- 10
xstart <- c(time=4,susceptible=400,infected=70,recovered=0) #initial conditions
params <- c(mu=4.5,beta=8.5 ) #model parameters

require(plyr)
simdat <- rdply(
                nsims,
                SIR.simul(xstart,params)
                )
head(simdat)
plot(infected~time,data=simdat,type='n')

d_ply(simdat,".n",function(x)lines(infected~time,data=x,col=.n))

head(simdat)
plot(infected~time,data=simdat,type='n')

d_ply(simdat,".n",function(x)lines(infected~time,data=x,col=.n))





SIR.onestep <- function (x, params) {
  susceptible <- x[2] # susceptible
  infected <- x[3]  # Infected
  N <- susceptible+infected# Total number of people in population
  mu <- params["mu"] # recovery rate
  beta <- params["beta"] # trnasmission rate 
  ## each individual rate
  rates <- c(
             
             infection=mu*susceptible*infected/N,
             recovery=beta*infected
             
             )
  ## what changes with each event?
  transitions <- list( 
                      
                      infection=c(-1,1),
                      recovery=c(1,-1)
                      
                      )
  ## total event rate
  total.rate <- sum(rates)
  ## waiting time
  if (total.rate==0) 
    tau <- Inf
  else
    tau <- rexp(n=1,rate=total.rate)
  ## which event occurs?
  event <- sample.int(n=2,size=1,prob=rates/total.rate)
  x+c(tau,transitions[[event]])
}

SIR.simul <- function (x, params, maxstep = 10000) {
  output <- array(dim=c(maxstep+1,3))
  colnames(output) <- names(x)
  output[1,] <- x
  k <- 1
  ## loop until either k > maxstep or
  ## there are no more infectives
  while ((k <= maxstep) && (x["infected"] > 0)) {
    k <- k+1
    output[k,] <- x <- SIR.onestep(x,params)
  }
  as.data.frame(output[1:k,])
}

set.seed(56856583)
nsims <- 10
xstart <- c(time=0,susceptible=400,infected=70) #initial conditions
params <- c(mu=4.5,beta=8.5 ) #model parameters

require(plyr)
simdat <- rdply(
                nsims,
                SIR.simul(xstart,params)
                )
head(simdat)
plot(infected~time,data=simdat,type='n')

d_ply(simdat,".n",function(x)lines(infected~time,data=x,col=.n))

head(simdat)
plot(susceptible~time,data=simdat,type='n')

d_ply(simdat,".n",function(x)lines(susceptible~time,data=x,col=.n))



inverse_logit <- function(x) {
    p <- exp(x) / (1 + exp(x))  # Maps R to [0, 1]
    return(p)
}
curve(inverse_logit, -10, 10)  # Sanity check

loglik <- function(logit_beta_gamma=5, df) {
    stopifnot(length(logit_beta_gamma) == 2)
   beta <- inverse_logit(logit_beta_gamma[1])
    gamma <- inverse_logit(logit_beta_gamma[2])
    dS <- -diff(df$S)
        dR <- diff(df$R)
    n <- nrow(df)
    pr_dS <- 1 - (1-beta)^df$I[seq_len(n-1)]  # Careful, problematic if 1 or 0
        return(sum(dbinom(dS, size=df$S[seq_len(n-1)], prob=pr_dS, log=TRUE) +
               dbinom(dR, size=df$I[seq_len(n-1)], prob=gamma, log=TRUE)))
}

get_estimates <- function() {
    df <- simulate()
    mle <- optim(par=c(-4, 0), fn=loglik, control=list(fnscale=-1), df=df)
    beta_gamma_hat <- inverse_logit(mle$par)
    names(beta_gamma_hat) <- c("beta", "gamma")
    return(beta_gamma_hat)
}

set.seed(54321999)

df <- simulate()
df_melted <- melt(df, id.vars="t")
p <- (ggplot(df_melted, aes(x=t, y=value, color=variable)) +
      geom_line(size=1.1) + theme_bw() +
      xlab("time") +
      theme(legend.key=element_blank()) +
      theme(panel.border=element_blank()))
p

## Sampling distribution of beta_gamma_hat
estimates <- replicate(100, get_estimates())
df_estimates <- as.data.frame(t(estimates))










































