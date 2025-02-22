import pandas as pd
import os
import dash
from dash import dcc, Dash, html, dash_table, callback, Output, Input
from dash.dependencies import Input, Output
import plotly.express as px
from dash import dcc



df = pd.read_csv(r'D:\ssj-30262\docs\Lectures\Week10_Plotly\service_311.csv', encoding='ISO-8859-1')

app = Dash()

# App layout
app.layout = html.Div( [
    html.Div(children='My First App with Data',
              style={'textAlign': 'center', 'color': 'blue', 'fontSize': 30}),
    
    html.Div(children =dash_table.DataTable(data=df.to_dict('records'), page_size=10, style_table={'overflowX': 'auto'})),
    
    dcc.RadioItems(options=['daytime', 'nighttime', 'All'], value='All', id='controls-and-radio-item'),
    dcc.Graph(figure = {}, id = "controls-and-graph")
])

@callback(
    Output(component_id='controls-and-graph', component_property='figure'),
    Input(component_id='controls-and-radio-item', component_property='value')
)

def update_graph(time_selected):
    if time_selected == 'All':
        filter_df = df
    else:
        filter_df = df[df['time_of_day'] == time_selected]
        
    fig = px.histogram(filter_df, x = "weekday", barmode='relative',histfunc='count',color='reason')

    return fig    
        
# Run the app
if __name__ == '__main__':
    app.run(debug=True)