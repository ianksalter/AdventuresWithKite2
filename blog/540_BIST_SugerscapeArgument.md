# Sugarscape (Lisbon - Saturday 17th March 2018 ) #

I love many things about living on a boat but going to the toilet is not one of them, especially when I'm staying in port for a long time. Kite has a perfectly good toilet on board, with a 30 litre black water holding tank, but that fills up quickly and then needs to be pumped out, so when moored, I generally use onshore facilities. Typically this means, if I wake up needing the loo at 4 or 5 in the morning, I have to get out of a warm bed, leave the boat and walk some distance. 

The author William Gibson [claims](https://en.wikiquote.org/wiki/William_Gibson)

>*"Naps are essential to my process. Not dreams, but that state adjacent to sleep, the mind on waking."*

As a morning person, this quote resonates with me. By the time I have walked to the toilet and back I'm usually already enjoying that 'mind on waking' state. When I return to the boat I do try and turn the lights out, climb under the covers and close my eyes, but nine times out of ten this doesn't work. Eventually my hand creeps out from the duvet and reaches for my tablet. With a thumb print, the screen brightens, lighting up Kites forward cabin as I follow my chain of thought along the internet. Today I'm on the trail of  [Cellular Automata](https://en.wikipedia.org/wiki/Cellular_automaton).

I think I was a student in my twenties when I became fascinated by [Conway's Game of Life](https://en.wikipedia.org/wiki/Conway%27s_Game_of_Life), my first exposure to cellular automata. Imagine if you will a giant grid of squares. These are the cells. For the game of life, each cell may be either alive (say black) or dead (say white). The grid (the automatum) changes from one time period to the next based upon some simple cellular level rules. For the game of life the rules are applied to each cell based upon the cell's neighbours, the eight surrounding cells. The rules are (NOTE see about replacing with a graph):

1. Any live cell with fewer than two live neighbours dies, as if caused by underpopulation.
2. Any live cell with two or three live neighbours lives on to the next generation.
3. Any live cell with more than three live neighbours dies, as if by overpopulation.
4. Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction.

These simple rules give rise to surprisingly complex and beautiful behaviour. The image below shows a series of shapes called gliders that over time move towards the bottom right of the frame. These gliders are being manufactured by a glider gun at the top of the picture.

![**A Glider Gun in Conways Game of Life**](../images/Gospers_glider_gun.gif "GameOfLife")  

Now, however, I'm thinking about a different class of cellular automata altogether;  [Sugarscape](https://en.wikipedia.org/wiki/Sugarscape). These I first encountered in Eric Beinhocker's ["The Origin of Wealth: Evolution, Complexity and the Radical Remaking of Economics"](https://www.goodreads.com/book/show/22456.The_Origin_of_Wealth) which reports the work of Joshua M. Epstein and Robert L. Axtell at the University of Maryland, originally published in the book ["Growing Artificial Societies:Social Science from the Bottom Up"](https://mitpress.mit.edu/books/growing-artificial-societies).

In Sugarscape each cell of the automatum grid contains amounts of a replenished resource; sugar. Roaming around the grid is a set of turtles who consume the sugar. There are a multitude of different sugarscape simulations. My early morning web search throws up one called [Sugarscape Wealth Distribution](http://ccl.northwestern.edu/netlogo/models/Sugarscape3WealthDistribution). This is implemented in [NetLogo](http://ccl.northwestern.edu/netlogo/index.shtml) a freely downloadable programming environment created by the [Northwestern University's CCL](http://ccl.northwestern.edu/). 

To simulate individual differences, each turtle in Wealth Distribution Sugarscape has three randomly assigned attributes:
 
 * **Lifespan** between 60 and 100 time periods
 * **Metabolic Rate** between 1 and 4; the amount of sugar the turtle needs to consume to stay alive to the next time period.
 * **Vision** between 1 and 6; the distance in terms of cells that turtle can see in order to chose the next place to consume sugar. 
 
Each turtle can keep also any excess sugar they consume, this being the **Wealth** that is being distributed. Turtles die when the reach their allotted lifespan or if they don't have enough sugar for their metabolic rate.
 
 I think I have NetLogo already so I climb out of bed and fetch my laptop and, while I'm at it Beinhocker's book, from the main cabin. Back under the covers I soon find the appropriate chapter, the book uses agents instead of turtles which confuses me a little, but once I have figured this out, words leap out of the page at me:
 
 >*"Epstein and Axtell noticed something very interesting about how the distribution of wealth evolved over time. At the beginning of the simulation, Sugarscape is a fairly egalitarian society and the distribution of wealth is a smooth, bell shaped curve with only a few very rich agents, a few very poor and a broad middle class. In addition the distance between the richest and the poorest agents is relatively small. As time passes however, this distribution changes dramatically. Average wealth rose as agents convened on the two sugar mountains but the distribution of wealth became very skewed, with a few emerging superrich agents, a long tail of upper-class yuppie agents, a shrinking middle class, and then a big, growing underclass of poor agents."* 
 
 I wonder if I can recreate this so I switch on my laptop and start running Sugarscape Wealth Distribution simulations. For a moment I pause and reflect upon what sort of human being I am with this sort of interest at stupid o'clock in the morning, but then I just sigh at myself and dive back into NetLogo.
 
  ![**NetLogo: Sugarscape Wealth Distribution**](../images/NetLogo.png "NatLogo")  

The left of the screen allows me to set parameters for the simulation. I can control the initial population of turtles and set the amount of sugar. I can also setup a new random configuration of turtles and run the simulation as well as color code the turtles by vision or metabolism. The middle pane is used to show the running, or indeed paused, simulation. 

The right hand side presents a visualisation of some statistics of the simulation. At any point in time, wealth distribution is shown using a histogram (bar chart) and a [Lorenz curve](https://en.wikipedia.org/wiki/Lorenz_curve). There is more equality in a population when the lorenz curve is closer to the diagonal line of equality and less as it moves down and to the right. The change in wealth distribution over time is given in the bottom left panel which shows the changing [GINI Index (or Coefficient)](https://en.wikipedia.org/wiki/Gini_coefficient). This number gives a single number for wealth distribution where 0 means totally equal and 1 means one turtle (or agent) owns all the wealth. 

GINI was developed to measure distribution of wealth and income for countries and is regularly reported by organisations like the [World Bank](https://en.wikipedia.org/wiki/World_Bank) which [currently reports](https://data.worldbank.org/indicator/SI.POV.GINI) Germany as having a GINI of 0.314, the UK 0.341 and the US 0.41, making Germany the most and the US the least egalitarian. NOTE add time series table here with some explanation + work out how Labour and Tories add to and remove from GINI.

I play with the parameters looking at how wealth distribution is affected. When sugar endowment is low I seem to be able to replicate the situation described by Beinhocker, but when these values are high I get a more equal distribution. I sit back for a little and wonder what would happen if you applied a basic income approach to this model. How would it effect the wealth distribution? I briefly look at the code underlying the model to see how I might do this before typing the words "Sugarscape Basic Income" into Chrome.

It's a little way down the page that I see ["Real freedom for all turtles in Sugarscape?"](https://www.researchgate.net/publication/290429313_Real_freedom_for_all_turtles_in_Sugarscape). In this book chapter, the author, French academic Paul-Marie Boulanger, describes the Wealth Distribution model, which he calls Sugarscape 1, as

>*"a world of "everyone for himself", where each individual not only pursues his own welfare without caring at all for others but, also, without being aware of the benefit he could get himself from improved cooperation and risk sharing mechanisms."*

For his study, Boulanger creats two models with added "solidarity" that he calls Sugarscape 2 and 3. 

Both the new models have a fixed rate sugar income tax which pays into a welfare pot. Sugarscape 2 has a traditional welfare system, where only those with not enough sugar to survive till the next turn are given a sugar grant from the welfare pot. Sugarscape 3 implements the notion of basic income, where everyone gets a grant from the pot regardless of their finances. As I start to read the paper a warm feeling comes over me. I have been using the internet for well over twenty years, I remember the first web browser Mozilla 1.0, but I am still in awe of the fact that sometimes you can just think of doing something, type the words into a browser, and find that someone has already done the work and saved you all that effort.

Boulanger is interested in two outcomes:

* **Turtles Probablity of Survival** this is determined for the average turtle but also broken down into three groups:
    + **Lucky Turtles** - that have good vision and low metabolism
    + **Unlucky Turtles** - that have poor vision and high metabolism
    + **Middles** - Turtles that have average metabolism and vision
* **GINI Coefficient**

To determine these outcomes, Boulanger averages across multiple smimulations for Sugarscape 1 and for each combination of tax rate and grant for Sugarscape 2 and 3.

He concludes that:

>*"... Sugarscape 2 doesn’t seem to give better prospects for the average turtle than the
world without solidarity. But it is clearly more advantageous for the "unluckies" whose survival chances are higher in almost every scenario than in Sugarscape 1."*

The basic income model seems to triumph:

>*"Sugarscape 3 offers better life chances for the whole population and also for every subgroup."*
   
There are wrinkles to the work though, for both Sugarscape 2 and 3 it appears to be:

>*"...that for any given level of the grant, there is only a very narrow range of
   values of the tax rate which is favourable to turtles’ welfare"*
   
This just wets my appetite, and now I have a desire to explore these models further. Unfortunately despite searching the web I cant find a copy of the actual code. As the dawn breaks I lie back in bed thinking that at least I have found another interesting argument for the basic income flat tax combination.


Add his comments about the model

As the rain beats down onto to Kite I spend my day hapily writing and following up leads

 
