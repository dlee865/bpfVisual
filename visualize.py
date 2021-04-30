#!/usr/bin/python3

import pandas as pd
import plotly.express as px
import dash
import dash_core_components as dcc
import dash_html_components as html
from dash.dependencies import Input, Output


biotop_df = pd.read_csv("./output/bIO_top.csv")
llcstat_df = pd.read_csv("./output/llc_stat.csv")
funccount_df = pd.read_csv("./output/funccount.csv")
#tplist_df = pd.read_csv("./output/tplist.csv")
#uthreads_df = pd.read_csv("./output/uthreads.csv")
ucalls_df = pd.read_csv("./output/ucalls.csv")
#stackcount_df = pd.read_csv("./output/stackcount.csv")
#sslsniff_df = pd.read_csv("./output/sslsniff.csv")

external_stylesheets = ['https://codepen.io/chriddyp/pen/bWLwgP.css']

app = dash.Dash(__name__, external_stylesheets=external_stylesheets)


app.layout = html.Div(children=[
    html.H1('ebpfVisual', style={'color': 'black', 'background': 'grey', 'display': 'flex', 'justify-content': 'center'}),
    # All elements from the top of the page
    html.Div([
        html.H2('Memory Hierarchy'),
    ]),

    html.Div([
        html.Div([
            dcc.Graph(
                id='biotop',
            ),  
            html.Button("Switch Axis", id='btn', n_clicks=0)
        ], className='six columns'),
        html.Div([
            dcc.Graph(
                id='llcstat',
            ),  
        ], className='six columns'),
    ], className='row'),

    html.Div([
        html.H2('File System')
    ]),
    # New Div for all elements in the new 'row' of the page
    html.Div([
        #html.H2('File System'),
        html.Div([
            dcc.Graph(
                id='funccount',
            ),
        ], className='six columns'),
        #html.H2('File System'),
        html.Div([
            dcc.Graph(
                id='ucalls',
            ),
        ], className='six columns'),
    ], className='row'),

],)

@app.callback(
    Output("biotop", "figure"), 
    [Input("btn", "n_clicks")]
)
def display_biotop(n_clicks):
    if n_clicks % 2 == 0:
        biotop_scatter = px.scatter(biotop_df, x = "AVGms", y = "Kbytes")
    else:
        biotop_scatter = px.scatter(biotop_df, x = "Kbytes", y = "AVGms")
      
    return biotop_scatter

@app.callback(
    Output("llcstat", "figure"), 
    [Input("btn", "n_clicks")]
)
def display_llcstat(n_clicks):
    if n_clicks % 2 == 0:
        llcstat = px.bar(llcstat_df, x = "CPU", y = "HIT%")
    else:
        llcstat = px.bar(llcstat_df, x = "CPU", y = "HIT%")

    return llcstat

@app.callback(
    Output("funccount", "figure"), 
    [Input("btn", "n_clicks")]
)
def display_funccount(n_clicks):
    if n_clicks % 2 == 0:
        funccount = px.bar(funccount_df, x = "FUNC", y = "COUNT")
    else:
        funccount = px.bar(funccount_df, x = "COUNT", y = "FUNC")
    
    return funccount

@app.callback(
    Output("ucalls", "figure"), 
    [Input("btn", "n_clicks")]
)
def display_ucalls(n_clicks):
    if n_clicks % 2 == 0:
        ucalls = px.bar(ucalls_df, x = "METHOD", y = "# CALLS")
    else:
        ucalls = px.bar(ucalls_df, x = "# CALLS", y = "METHOD")
      
    return ucalls

'''
@app.callback(
    Output("tplist", "figure"), 
    [Input("btn", "n_clicks")]
)
def display_llcstat(n_clicks):
    if n_clicks % 2 == 0:
        tplist = px.bar(tplist_df, x = "CPU", y = "HIT%")
    else:
        tplist = px.bar(tplist_df, x = "CPU", y = "HIT%")
      
    return tplist
'''

app.run_server(debug=True)