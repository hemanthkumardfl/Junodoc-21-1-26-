({
	createChart : function (component, helper) {
        
        var ready = component.get("v.ready");
        if (ready === false) {
            return;
        }
        var chartCanvas = component.find("chart").getElement();
         
        var action = component.get("c.getreport");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('reportResultData -------> '+response.getReturnValue());
                var reportResultData = JSON.parse(response.getReturnValue());
                var chartData = [];
                var chartLabels = [];
                for(var i=0; i < (reportResultData.groupingsDown.groupings.length); i++){
                    //Collect all labels for Chart.js data
                    var labelTemp = reportResultData.groupingsDown.groupings[i].label;
                    chartLabels.push(labelTemp);

                    var keyTemp = reportResultData.groupingsDown.groupings[i].key;

                    //Collect all values for Chart.js data
                    var valueTemp = reportResultData.factMap[keyTemp + '!T'].aggregates[0].value ;
                    chartData.push(valueTemp);
                }
                console.log('chartData ------> '+JSON.stringify(chartData));
                //Construct chart
                var chart = new Chart(chartCanvas,{
                    type: 'doughnut',
                    data: {
                        labels: chartLabels,
                        datasets: [
                            {
                                label: "test",
                                data: chartData,
                                backgroundColor: [
                                    "#52BE80",
                                    "#76D7C4",
                                    "#1E8449",
                                    "#2ECC71",
                                    "#FFB74D",
                                    "#E67E22",
                                    "#F8C471",
                                    "#3498DB",
                                    "#00BCD4",
                                    "#D32F2F",
                                    "#82E0AA",
                                    "#AFB42B"
                                ]
                            }
                        ]
                    },
                    options: {
                        cutoutPercentage: 75,
                        maintainAspectRatio: false,
                        legend: {
                            display: true,
                            position:'right',
                            fullWidth:false,
                            reverse:true,
                            labels: {
                                fontColor: '#000',
                                fontSize:10,
                                fontFamily:"Salesforce Sans, Arial, sans-serif SANS_SERIF"
                            }
                        }
                    }
                });
                
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message on createReport: " +
                                    errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
        
    },
    
    getData : function(component, helper) {
            
            //Set report name 
            component.set('v.name', 'Expenditure Report');

            var dataCategories = ['1-2016','2-2016','3-2016','4-2016','5-2016','6-2016','7-2016','8-2016','92016','10-2016','11-2016','12-2016'];
            var costValues = [30000, 10000, 45000, 65000,30000, 40000, 25000, 95000,30000, 10000, 75000, 55000,];

            var costChart1 = new Highcharts.Chart('chart-container1', {
                                    chart: {
                                        marginTop: 20,
                                        type: 'column',
                                        width:1100,
                                        events:{
                                            click:function(e){
                                                if (e.xAxis[0].value < 0) {
                                                    helper.barClick(cmp,dataCategories[0]);
                                                }else{
                                                    helper.barClick(cmp,dataCategories[Math.round(e.xAxis[0].value)]);
                                                }
                                            }
                                        }
                                    },
                                    title: {
                                        style: {
                                            display: 'none'
                                        }
                                    },
                                    xAxis: {
                                        categories: dataCategories ,
                                        title: {
                                            text: ''
                                        },
                                        labels: {
                                            style: {
                                                fontSize:'12px'
                                            }
                                        }
                                    },
                                    tooltip: {
                                        style: {
                                            display: 'none'
                                        }
                                    },
                                    yAxis: {
                                        title: {
                                            text: ''
                                        },
                                        
                                        labels: {
                                            style: {
                                                fontSize:'12px'
                                            }
                                        }
                                    },
                                    series: [{
                                        name: '',
                                        cursor: 'pointer',
                                        
                                        //Pass the values through chartValues attribute
                                        data: costValues ,
                                        showInLegend: false,
                                        minPointLength:2
                                    }],
                                    colors: ['#148ed8' ],
                                    navigation: {
                                        buttonOptions: {
                                            enabled: false
                                        }
                                    },
                                    credits: {
                                        enabled: false
                                    }
                                });
            //Get SVG element and then serialize it to convert to a stream of String
       		
    },
    
    /*downloadReport : function(component, helper){
        
        //Get SVG element and then serialize it to convert to a stream of String
        var svg = document.getElementById('chart-container1').childNodes[0];
        var serializer = new XMLSerializer();
        var svgString = serializer.serializeToString(svg);
        var canvas = document.getElementById("chartimgCanvas1");
        var render_width = 1000;
        var render_height = 600;

        //CHange/Set Canvas width/height attributes to reset origin-clean flag
        canvas.height = render_height;
        canvas.width = render_width;

        //Use canvg library to parse SVG and draw the image on given canvas
        canvg(canvas, svgString, {
            useCORS: true,
            scaleWidth: render_width,
            scaleHeight: render_height,
            ignoreDimensions: true,
            log: true
        });

        //Convert canvas to png formated dataURL and save the body of it
        var rawImage = canvas.toDataURL("image/png");
        var dataArray = rawImage.split(',');            
        component.set('v.base64',dataArray[1]);
        console.log(rawImage);
        this.generateReport(component);

    },

    generateReport : function(component){
        //Send data to generate Report
        var action = component.get('c.getDownloadReport');  
        action.setParams({
            'selectedReport' : component.get('v.selectedReport'), 
            'imgData' : component.get('v.base64'), 
            'name' : component.get('v.name')
        });
        action.setCallback(this,function(response) {
            if (response.getState() === 'SUCCESS') {
                var result = response.getReturnValue();
                
                //Navigate to Report Store
                var urlEvent = $A.get("e.force:navigateToURL");
                urlEvent.setParams({
                  "url": "/reportdock"
                });
                urlEvent.fire();       
            }
            else {
                console.log('ERROR: ', response.getError());
            }
        });
        $A.enqueueAction(action);
    }, */

	download : function(component, helper){
       // alert('download');
        var download = document.getElementById("download");
        var image = document.getElementById("chart").toDataURL("image/png")
                    .replace("image/png", "image/octet-stream");
        console.log('image ------> '+image);
        //download.setAttribute("href", image);
        var dataArray = image.split(',');
        var imageId = dataArray[1];
        var action = component.get("c.getPdfContent");
        action.setParams({
            "imageId" : imageId
        });
        action.setCallback(this, function(response){
        	var state = response.getState();
            if(state === "SUCCESS"){
                var result = response.getReturnValue();
            	var url = '/apex/TestVF?id=' + result;
                component.set("v.Url",url);
                component.set("v.isUrl",true);
                 component.set("v.isCanvas",false);
                component.set("v.Spinner",false);
        		//window.open(url, '_self');	    
            }
        });
        $A.enqueueAction(action);
    }
    
})