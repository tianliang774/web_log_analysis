<template>
  <div id="app">
    <ul class="charts">
      <li><ISPChart /></li>
      <li><TopNChart /></li>
      <li><AccessTimeChart /></li>
      <li><AccessSourceChart /></li>
      <li><SearchEnginesChart /></li>
      <li><AccessOSChart /></li>
      <li><AccessAreaChart /></li>
    </ul>  
  </div>

</template>

<script>
import ISPChart from './components/ISPChart.vue'
import TopNChart from './components/TopNChart.vue'
import AccessTimeChart from './components/AccessTimeChart.vue'
import AccessSourceChart from './components/AccessSourceChart.vue'
import SearchEnginesChart from './components/SearchEnginesChart.vue'
import AccessAreaChart from './components/AccessAreaChart.vue'
import AccessOSChart from './components/AccessBroswerChart.vue'

export default {
  name: 'App',
  components: {
    ISPChart,
    TopNChart,
    AccessTimeChart,
    AccessSourceChart,
    SearchEnginesChart,
    AccessAreaChart,
    AccessOSChart
  }
}
</script>

<style>
#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
  margin-top: 60px;
}
.ip{
    width: 500px;
    height: 300px;
}
.charts{
  width: 1226px;
  list-style: none;
  margin: 0 auto;
  overflow: hidden;
}
.charts li{
  width: 400px;
  height: 300px;
  float: left;
  background-color: white;
  margin-bottom: 10px;
  overflow: hidden;
  border: 1px solid #d3d3d3;
}
.charts li:nth-child(2){
  margin-left: 10px;
}
.charts li:nth-child(3){
  margin-left: 10px;
}
.charts li:nth-child(5){
  margin-left: 10px;
}
.charts li:nth-child(6){
  margin-left: 10px;
}
.charts li:nth-last-child(1){
  width: 100%;
  height: 400px;
}
body{
    background-color: #f5f5f5;
}
</style>
