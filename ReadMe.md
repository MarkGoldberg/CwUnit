# CwUnit #
## a UnitTesting Framework written in and for Clarion for Windows ##


## License ##
Distributed under [GPL 3.0](http://www.gnu.org/licenses/gpl-3.0.txt "GPL 3.0")

## Road Map ##
1. Initial Public Release
2. Summarize Test Runs
3. Interactive Test Runner
4. Directory Watcher
5. Improve Test Results
	1. Want results of each method call in the results
	2. Overall Pass/Fail will be the same


## Concerns ##
1. Hard coded paths in certain files
2. Complexity relating to multiple result sets, but not taking advantage of it at this time.
3. Possible incorrect of terms, such as TestFixture
4. Inability to write a test for IsNull


## Getting Started ##
1. Clone the Repo
2. Configure your clarion IDE to point to CWUnit
		1. Tools.Options.Clarion.ClarionForWindows.Versions.Tab[Redirection File]
		2. Click [Add], Macro=CwUnit, Value=C:\....\CwUnit  where the .... is where you cloned the repo
3. Launch DbgView or DebugView++
4. Compile the Solution ...\CwUnit\CwUnit.sln
	1. Observe test output in DebugView++
	2. This occurs as ExampleTest has a Post-build event that runs [..\CwUnit\CwUnit ExampleTest.DLL ]
5. Create your own test DLL
	1. Configure the IDE
		1. Copy the .XPT and .XFT 
			1. from "CwUnit\IDE Configuration\FileNew QuickStarts" 
			2. to "%CWRoot%\bin\Addins\BackendBindings\ClarionBinding\ClaironWin\Templates"
			3. Relaunch the IDE so it notices the new files
	2. Create a new project, and use the Quick Start [CwUnit TestDLL]
		1. Ensure that your .RED will find CwUnit
			1. Either alter your base .RED or create a project specific one
			2. IDE.SolutionExplorer Highlight the .CwProj & MouseRight
				1. Create Redirection File in the project directory
				2. Add **{include %CwUnit%\CwUnit.RED}** to your .RED
		2. Compile
			1. You may wish to add configure your .cwproj to automatically run
	3. To add another module of tests to your project
		1. IDE.File.New.File   
		2. Select [Create file inside project]
		3. Select QuickStart[CwUnit Test Member Module]
		4. Set The FileName of the module
		5. Click Create
		6. A few manual things - as described in the module
			1. Fix the member statement, fill in your global module
			2. Copy the Module & Prototype to the global map
			3. Copy the AddTests line to the MyTestSuite.Setup
6. To run your tests:   **CwUnit Your.DLL**
7. For a Usage: **CwUnit /?**

## Writing Tests ##
1. Each test is a method that takes a single argument
     
      `MyTests.IsTrue         PROCEDURE(*CwUnit_ctResult Test)`
2. Each test needs to be added in AddTests method called from the main module   
     `MyTests.AddTest('IsTrue(1)'   , ADDRESS(MyTests.SomeTest))`

     `MyTests.AddTest('IsTrue(0)'   , ADDRESS(MyTests.IsTrue)  , 0)`

     `MyTests.AddTest('IsTrue(2)'   , ADDRESS(MyTests.IsTrue)  , 2)`
		
    Notice that you can add some data to be passed into the test
    ***PLEASE do NOT make one test dependent upon another test***

			

## Release Notes ##
### CwUnit Initial Public Release - May 26th 2014 ###
