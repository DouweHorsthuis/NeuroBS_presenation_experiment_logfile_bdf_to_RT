<!--
This is all based on https://github.com/othneildrew/Best-README-Template, othneildrew's "best-README-Template". I only made some edits 
that I thought were making things clearer

When starting a new readme file, to avoid retyping too much info. Do a search and replace with your text editor for the following:**
`DouweHorsthuis`, `NeuroBS_presenation_experiment_logfile_bdf_to_RT`, `DouweJhorsthuis`, `douwehorsthuis@gmail.com`, `Calculating Presentation experiment RT using Logfile or BDF  `, `This project was made to only calculate RT and transform it into a table and potentially an excel sheet `, 'douwe-horsthuis-725bb9188'

If you want to use markdown or HTML but you are not familiar check: https://www.markdownguide.org/basic-syntax/#reference-style-links
-->

<!-- if you want different custom or unique shields see https://shields.io/category/build  -->
[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![MIT License][license-shield]][license-url]
[![LinkedIn][linkedin-shield]][linkedin-url]



<!-- there is no way to align things when using Markdown, so in these instances we use HTML -->
<!-- if you want to use a logo, make sure to upload your logo to your NeuroBS_presenation_experiment_logfile_bdf_to_RT, or link to another place where it's online -->

<br />
<p align="center">
  <a href="https://github.com/DouweHorsthuis/NeuroBS_presenation_experiment_logfile_bdf_to_RT/">
      <img src="images/logo.jpeg" alt="Logo" width="286" height="120">
  </a> 

<h3 align="center">Calculating Presentation experiment Reaction Time (RT) using Logfile or BDF (Work in progress) </h3>

<h4 align="center">This project was made to only calculate RT and transform it into a table and potentially an excel sheet </h4>

<!-- I think the table of contents is cleaner and more readable in markdown, so using markdown for these parts
the basics are, put whatever you want to show up in [] put whatever you want to link to in () the linking part cannot
have any spaces/characters, replaces spaces with - (_ does not work) the numbering should be indifferent (as you can see below) -->

**Table of Contents**
  
1. [About the project](#about-the-project)
    - [Built With](#built-with)
2. [Getting started](#getting-started)
    - [Prerequisites](#prerequisites)  
3. [Usage](#usage)
    - [Logfile_RT](#logfile_rt)
    - [BDF_RT](#BDF_RT)
3. [License](#license)
3. [Contact](#contact)






<!-- ABOUT THE PROJECT -->
## About The Project
This project was made to look at the RT and the inter stimulus interval that took place before that reaction of a experiment ran using Presentation® (Neurobehavioral Systems). It can look at the logfiles that are the output of this program, or if the data is saved in a BDF file it is possible to look at that instead. It save the reaction time per trial per participant per condition. It can also do this for multiple groups (saving the groups in separate pages on the excel). If you want to use the BDF script you also need EEGlab, as it uses EEGlab functions and structures.


### Built With

* [Matlab](https://www.mathworks.com/)
* [EEGlab](https://sccn.ucsd.edu/eeglab/index.php)

<!-- GETTING STARTED -->
## Getting Started

To get a local copy up and running follow these simple steps.

### Prerequisites
Software: If you want to use BDF files you'll need to have a copy of [EEGlab](https://sccn.ucsd.edu/eeglab/download.php) (these scripts works for version eeglab2019_1)


<!-- USAGE EXAMPLES -->
## Usage

There are 2 ways of running the script the first one (Logfile_RT) that is explained uses the logfiles created by the presenation experiment directly. The second one (BDF_RT) uses the BDF files to look at reaction time. The first one is a little bit more straight forward, but the second one allows for my variability. 

### Logfile_RT
This script needs you to define a couple of things, but should be easy to manipulate without needing extra plugins for Matlab
There are 2 variable that require some effort to find out. 

Basically setting these 2 should be the start and the ending of the RT. The easiest/quickest way to find these is to open a .log file and copy paste the whole thing into excel to get a little more structure. After that you look for the name of the event code (located in column 4). This is what you input as event_code_start. After that you count the amount of row between that event and the response event. Make sure that this is the same for most trials. Once you have a number, add this number to response_event. 

In the case that the response_event is sometimes after 2 rows and sometimes after 3, you can choose to go to the part of the script that is commanded out. Here you can set-up extra events that should be included. 
```matlab
event_code_start = 'name_of_the_eventcode'; % this should be the name of the event code (column 4) in the logfile, that starts the RT
response_event = 2; % how many rows after the event_code_start should the response happen.
```
The rest of the variables are pretty self explanatory

```matlab
name_logfile = 'nameofthefile';%this should be the name of your logfile, without the ID, it normally has the paradigm name
min_rt= 100;  %smallest possible RT in milisec
max_rt= 2000; %biggest possible RT in milisec
group =  {'TD'} ; % previous script had 2 groups, they can be added here. if you do update check line 22
blocks= 5; %amount of blocks/logfiles everyone did
home_path  = 'data\'; %place data is
save_path  = 'save\'; %place you want to save data
```
After running the script you'll end up with an excel with all your info, if you have more than 1 group, you should see that their info is on different sheets.
### BDF_RT
The reason to use this is because this way you can set up a sequence of triggers that happen before a reaction, so you can measure specific reactions to very specific events in the data. Just like the other script this script requires you to set some variables to begin with. 

```matlab
min_rt = 100; % in ms
max_rt = 1200;% in ms
type = {'bdf'}; % either bdf or set (choose .set if you have
name_savefile = 'How_to_name_the_full_data_set'; %How_to_name_the_full_data_set
group = { 'TD'  }; % previous script had 2 groups, they can be added here if needed , but also change the names of line 25 and 27 according
blocks= 1; %amount of blocks/logfiles everyone did
home_path  = 'filepath_to_data'; %place data & binlist is
save_path  = 'filepath_to_save'; %place you want to save data
cond_type={'B1(3)' 'B2(4)' 'B3(5)' 'B4(5)' 'B5(4)' 'B6(3)' 'B7(3)'}; %these are the bins you created in the binlist (bin number followed by first trigger number)
new_cond_type = {'cond1' 'cond1' 'cond1' 'cond2' 'cond2' 'cond2' 'cond2'}; %these will be the new names of the bins, to make it more clear.
condition_type = {'cond1' 'cond2'}; %how ever many conditions you want to plot can be assigned here
```
What is different here is that you have to set thing for your binlist. The way to figure out what to input is to first make your own binlist. Your binlist is a normal .txt file with a very specific [structure](https://github.com/DouweHorsthuis/NeuroBS_presenation_experiment_logfile_bdf_to_RT/blob/main/images/binlist.png)
See the example binlist in the tools folder. For more help check this [tutorial](https://github.com/lucklab/erplab/wiki/ERP-Bin-Operations).
Once you defined that you need to run the script until line 51. You can now open the following structure EEG.event. Here you should be able to find all the cond_type variables that you want to include. 

<!-- LICENSE -->
## License

Distributed under the MIT License. See `LICENSE` for more information.



<!-- CONTACT -->
## Contact

Douwe Horsthuis - [@DouweJhorsthuis](https://twitter.com/DouweJhorsthuis) - douwehorsthuis@gmail.com

Project Link: [https://github.com/DouweHorsthuis/NeuroBS_presenation_experiment_logfile_bdf_to_RT/](https://github.com/DouweHorsthuis/NeuroBS_presenation_experiment_logfile_bdf_to_RT/)




<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[contributors-shield]: https://img.shields.io/github/contributors/DouweHorsthuis/NeuroBS_presenation_experiment_logfile_bdf_to_RT.svg?style=for-the-badge
[contributors-url]: https://github.com/DouweHorsthuis/NeuroBS_presenation_experiment_logfile_bdf_to_RT/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/DouweHorsthuis/NeuroBS_presenation_experiment_logfile_bdf_to_RT.svg?style=for-the-badge
[forks-url]: https://github.com/DouweHorsthuis/NeuroBS_presenation_experiment_logfile_bdf_to_RT/network/members
[stars-shield]: https://img.shields.io/github/stars/DouweHorsthuis/NeuroBS_presenation_experiment_logfile_bdf_to_RT.svg?style=for-the-badge
[stars-url]: https://github.com/DouweHorsthuis/NeuroBS_presenation_experiment_logfile_bdf_to_RT/stargazers
[issues-shield]: https://img.shields.io/github/issues/DouweHorsthuis/NeuroBS_presenation_experiment_logfile_bdf_to_RT.svg?style=for-the-badge
[issues-url]: https://github.com/DouweHorsthuis/NeuroBS_presenation_experiment_logfile_bdf_to_RT/issues
[license-shield]: https://img.shields.io/github/license/DouweHorsthuis/NeuroBS_presenation_experiment_logfile_bdf_to_RT.svg?style=for-the-badge
[license-url]: https://github.com/DouweHorsthuis/NeuroBS_presenation_experiment_logfile_bdf_to_RT/blob/master/LICENSE.txt
[linkedin-shield]: https://img.shields.io/badge/-LinkedIn-black.svg?style=for-the-badge&logo=linkedin&colorB=555
[linkedin-url]: https://linkedin.com/in/douwe-horsthuis-725bb9188