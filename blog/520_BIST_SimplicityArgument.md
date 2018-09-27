## The Simplicity Argument ##

In the night we sail towards the Gibraltar Straights I stare at my written notes notes on the [UK Tax system for 2016/17](https://www.gov.uk/government/publications/rates-and-allowances-income-tax/income-tax-rates-and-allowances-current-and-past). My goal is to illustrate the simplicity of Basic Income Simple Tax relative to the existing UK system. Given this intention it is acceptable for me to simplify my presentation. For, if I can show that BIST is significantly simpler than a simple version of the UK system, then I have certainly shown that it is simpler than the actual system.

My first simplification is only to consider the following components:

* Income Tax
* National Insurance
* Universal Credit
 
It is my intention to describe each one of these in a little detail to prove my point. 

### Income Tax ###

The calculation of 2016/17 UK Income Tax depends upon a personal allowance which is a constant £11500 until income reaches £100,000 when it is withdrawn at a rate of 1 £ for every £2. I ignore married couples and blind persons allowances as a simplification and draw a graph of the Personal Allowance in my pad:

![*UK Personal Allowance 2016/2017*](../plots/PersonalAllowance.png "UK Personal Allowance 2016/17")

Based on the personal allowance there are a set of tax bands for which tax rates apply:

* From 0 income to the personal allowance: 0%
* For the first £33,500 after the personal allowance: 20%
* From £32,000 to £150,000: 40%
* Beyond £150,000: 45%

These tax rates are actually different for dividend income, but I ignore this as a simplification and after some, not inconsiderable, working out draw the following graph of Initial Income less Income Tax:

![*UK Income Tax 2016/2017*](../plots/InitialIncomeLessIncomeTax.png "UK Income Tax 2016/17")

This shows initial income with income tax subtracted. Note the bumps in the line. These represent points where different rates apply as well as where the personal allowance is gradually withdrawn. 

### National Insurance ###  

National Insurance was added to the UK system by the [1945 Atlee Labour Government](https://en.wikipedia.org/wiki/Attlee_ministry) as the means to pay for the the Welfare State. It was an approach that has been copied worldwide.  

There are different class of National Insurance contribution. Class 1 contributions are paid out for employees working for an employer. As a simplification I ignore all other classes of contribution, contracted out pensions and reduced rates for apprentices and the young.

National insurance is paid by both employers and employees. For employee contributions there are two of thresholds that matter:

* Primary Threshold of £8164 where employees start contributing at 12%
* Upper Earnings Limit of £45000 above which employees contribute at 2%

Again I spend time calculating so that I can draw the graph of Initial Income less Income Tax and Employees National Insurance:  

![*UK Net Income After Tax and Employees National Insurance 2017/2018*](../plots/InitialIncomeLessTaxAndEmployeesNI.png "UK Net Income After Tax and Employees National Insurance 2017/2017")

### Universal Credit ### 

[Universal Credit](https://en.wikipedia.org/wiki/Universal_Credit) was introduced by the [Coalition Government](https://en.wikipedia.org/wiki/Cameron%E2%80%93Clegg_coalition) in 2013. It aims to simplify the benefit system and incentivise work by integrating a number of existing benefits.

I look at the notes in my note pad and remember how complicated universal credit it is to calculate. However after a while I see that, if I just consider the case of a single person, with no children, who is over the age of 25 and all of whose income is earned, then I only need to worry about:

* A Standard Allowance of £4461.84 annually.
* The Earned Income Taper which reduces universal credit by 63 pence for every £1 earned.

With this information I draw a new graph in my pad which takes into account the effects of Income Tax, Employees National Insurance and Universal Credit. In doing this I change the scale to focus in on the impact of Universal Credit: 

![*Income after Tax, National Insurance and Universal Credit*](../plots/FinalIncomeEarned.png "Income after Tax, National Insurance and Universal Credit")

### Conclusion ### 

The graphs created so far in the simplicity argument can be combined to see the effect tax, national insurance and universal credit have on initial income:

![*Effect of Income Tax National Insurance and Universal Credit*](../plots/FinalVsInitialIncome.png "Effect of Income Tax National Insurance and Universal Credit") 

Spot the similarity with the Final Income under BIST graph.  Just to check I draw another a picture of BIST this time with the amount set to the Universal Credit Standard Amount of £4461.84 and a rate of 0.37. 

![*Simulating the UK System with BIST*](../plots/FinalIncomeBISTSimulation.png "Simulating the UK System with BIST") 

BIST is more generous to the poor, but otherwise seems to simulate the UK system pretty closely, at least at incomes below £50,000.

I am truely staggered that something built from a *personal allowance*, *withdrawal rate*, *tax thresholds and rates*, *national insurance thresholds and rates*, *universal credit allowances* and *tapers* can be simulated so closely with just an *amount* and a *rate*. Some might argue that the UK system gives greater control and while this is undeniably true, I would question whether such control is really needed. On the other hand the relative simplicity of Basic Income Simple Tax approach seems undeniable.


YOU ARE HERE!!!!!!!




Save this stuff for another agrument about marginal rates 

Can we not survive on a simple standard rate of tax? Is there any good reason in the current system that 

* someone who earns £5000 a year gets 37 pence for each extra pound earned 

while 

* someone getting £7500 gets to keep the whole pound,

or, at the other end of the scale

* someone earning £110,000 gets to keep 38 pence

while

* someone earning £125,000 gets to keep 58 pence?  


