# -*- coding: utf-8 -*-
# @Time    : 2021/9/24 21:01
# @Author  : Praise
# @File    : GA_VRPTW.py
# obj:
import math
import random
import numpy as np
import copy
import xlsxwriter
import matplotlib.pyplot as plt
import csv
import sys
class Sol():
    def __init__(self):
        self.obj=None
        self.node_id_list=[]
        self.cost_of_distance=None
        self.cost_of_time=None
        self.fitness=None
        self.route_list=[]
        self.timetable_list=[]

class Node():
    def __init__(self):
        self.id=0
        self.x_coord=0
        self.y_cooord=0
        self.demand=0
        self.depot_capacity=0
        self.start_time=0
        self.end_time=1440
        self.service_time=0
        self.T_expect=self.start_time   # 让预计时间等于开始时间

class Model():
    def __init__(self):
        self.best_sol=None
        self.demand_dict={}
        self.depot_dict={}
        self.depot_id_list=[]
        self.demand_id_list=[]
        self.sol_list=[]
        self.distance_matrix={}
        self.time_matrix={}
        self.number_of_demands=0
        self.vehicle_cap=0
        self.vehicle_speed=1
        self.pc=0.5
        self.pm=0.1
        self.popsize=100
        self.n_select=80
        self.opt_type=1
        self.customers_importance=[]
        self.f1_M = 100
        self.Cp_2 = 10


def readCSVFile(demand_file,depot_file,model):
    with open(demand_file,'r') as f:
        demand_reader=csv.DictReader(f)
        for row in demand_reader:
            node = Node()
            node.id = int(row['id'])
            node.x_coord = float(row['x_coord'])
            node.y_coord = float(row['y_coord'])
            node.demand = float(row['demand'])
            node.start_time=float(row['start_time'])
            node.end_time=float(row['end_time'])
            node.service_time=float(row['service_time'])
            node.T_expect = float(row['start_time'])    # 设置预计时间
            model.demand_dict[node.id] = node
            model.demand_id_list.append(node.id)
        model.number_of_demands=len(model.demand_id_list)

    with open(depot_file, 'r') as f:
        depot_reader = csv.DictReader(f)
        for row in depot_reader:
            node = Node()
            node.id = row['id']
            node.x_coord = float(row['x_coord'])
            node.y_coord = float(row['y_coord'])
            node.depot_capacity = float(row['capacity'])
            node.start_time=float(row['start_time'])
            node.end_time=float(row['end_time'])
            model.depot_dict[node.id] = node
            model.depot_id_list.append(node.id)

def calDistanceTimeMatrix(model):
    for i in range(len(model.demand_id_list)):
        from_node_id = model.demand_id_list[i]
        for j in range(i + 1, len(model.demand_id_list)):
            to_node_id = model.demand_id_list[j]
            dist = math.sqrt((model.demand_dict[from_node_id].x_coord - model.demand_dict[to_node_id].x_coord) ** 2
                             + (model.demand_dict[from_node_id].y_coord - model.demand_dict[to_node_id].y_coord) ** 2)
            model.distance_matrix[from_node_id, to_node_id] = dist
            model.distance_matrix[to_node_id, from_node_id] = dist
            model.time_matrix[from_node_id,to_node_id] = math.ceil(dist/model.vehicle_speed)
            model.time_matrix[to_node_id,from_node_id] = math.ceil(dist/model.vehicle_speed)
        for _, depot in model.depot_dict.items():
            dist = math.sqrt((model.demand_dict[from_node_id].x_coord - depot.x_coord) ** 2
                             + (model.demand_dict[from_node_id].y_coord - depot.y_coord) ** 2)
            model.distance_matrix[from_node_id, depot.id] = dist
            model.distance_matrix[depot.id, from_node_id] = dist
            model.time_matrix[from_node_id,depot.id] = math.ceil(dist/model.vehicle_speed)
            model.time_matrix[depot.id,from_node_id] = math.ceil(dist/model.vehicle_speed)

def selectDepot(route,depot_dict,model):
    min_in_out_distance=float('inf')
    index=None
    for _,depot in depot_dict.items():
        if depot.depot_capacity>0:
            in_out_distance=model.distance_matrix[depot.id,route[0]]+model.distance_matrix[route[-1],depot.id]
            if in_out_distance<min_in_out_distance:
                index=depot.id
                min_in_out_distance=in_out_distance
    if index is None:
        print("there is no vehicle to dispatch")
        sys.exit(0)
    route.insert(0,index)
    route.append(index)
    depot_dict[index].depot_capacity=depot_dict[index].depot_capacity-1
    return route,depot_dict

def calTravelCost(route_list,model):
    timetable_list=[]
    cost_of_distance=0
    cost_of_time=0
    f1=0
    f2=0
    for route in route_list:
        timetable=[]
        for i in range(len(route)):
            if i == 0:
                depot_id=route[i]
                next_node_id=route[i+1]
                travel_time=model.time_matrix[depot_id,next_node_id]
                departure=max(0,model.demand_dict[next_node_id].start_time-travel_time)
                timetable.append((departure,departure))
            elif 1<= i <= len(route)-2:
                last_node_id=route[i-1]
                current_node_id=route[i]
                current_node = model.demand_dict[current_node_id]
                travel_time=model.time_matrix[last_node_id,current_node_id]
                arrival=max(timetable[-1][1]+travel_time,current_node.start_time)
                departure=arrival+current_node.service_time
                timetable.append((arrival,departure))
                cost_of_distance += model.distance_matrix[last_node_id, current_node_id]
                cost_of_time += model.time_matrix[last_node_id, current_node_id]+ current_node.service_time\
                                + max(current_node.start_time - timetable[-1][1] - travel_time, 0)

                if current_node_id in model.customers_importance:
                    if arrival > current_node.end_time:
                        f1 += model.f1_M
                else:
                    if current_node.T_expect < arrival <= current_node.T_expect + 10:
                        f2 += model.Cp_2*(arrival - current_node.T_expect)
                    if current_node.T_expect + 10 < arrival:
                        f2 += model.Cp_2*(arrival - current_node.T_expect - 10)+10*model.Cp_2

            else:
                last_node_id = route[i - 1]
                depot_id=route[i]
                travel_time = model.time_matrix[last_node_id,depot_id]
                departure = timetable[-1][1]+travel_time
                timetable.append((departure,departure))
                cost_of_distance +=model.distance_matrix[last_node_id,depot_id]
                cost_of_time+=model.time_matrix[last_node_id,depot_id]
        timetable_list.append(timetable)
    return timetable_list,cost_of_time,cost_of_distance,f1,f2

def extractRoutes(node_id_list,Pred,model):
    depot_dict=copy.deepcopy(model.depot_dict)
    route_list = []
    route = []
    label = Pred[node_id_list[0]]
    for node_id in node_id_list:
        if Pred[node_id] == label:
            route.append(node_id)
        else:
            route, depot_dict=selectDepot(route,depot_dict,model)
            route_list.append(route)
            route = [node_id]
            label = Pred[node_id]
    route, depot_dict = selectDepot(route, depot_dict, model)
    route_list.append(route)
    return route_list

def splitRoutes(node_id_list,model):
    depot=model.depot_id_list[0]
    V={id:float('inf') for id in model.demand_id_list}
    V[depot]=0
    Pred={id:depot for id in model.demand_id_list}
    for i in range(len(node_id_list)):
        n_1=node_id_list[i]
        demand=0
        departure=0
        j=i
        cost=0
        while True:
            n_2 = node_id_list[j]
            demand = demand + model.demand_dict[n_2].demand
            if n_1 == n_2:
                arrival= max(model.demand_dict[n_2].start_time,model.depot_dict[depot].start_time+model.time_matrix[depot,n_2])
                departure=arrival+model.demand_dict[n_2].service_time
                if model.opt_type == 0:
                    cost=model.distance_matrix[depot,n_2]*2
                else:
                    cost=model.time_matrix[depot,n_2]*2
            else:
                n_3=node_id_list[j-1]
                arrival = max(departure + model.time_matrix[n_3, n_2], model.demand_dict[n_2].start_time)
                departure = arrival + model.demand_dict[n_2].service_time
                if model.opt_type == 0:
                    cost=cost-model.distance_matrix[n_3,depot]+model.distance_matrix[n_3,n_2]+model.distance_matrix[n_2,depot]
                else:
                    cost = cost - model.time_matrix[n_3, depot] + model.time_matrix[n_3, n_2] \
                           + max(model.demand_dict[n_2].start_time - arrival, 0) + model.time_matrix[n_2, depot]
            if demand<=model.vehicle_cap and departure <= model.demand_dict[n_2].end_time:
                if departure+model.time_matrix[n_2,depot] <= model.depot_dict[depot].end_time:
                    n_4=node_id_list[i-1] if i-1>=0 else depot
                    if V[n_4]+cost <= V[n_2]:
                        V[n_2]=V[n_4]+cost
                        Pred[n_2]=i-1
                    j=j+1
            else:
                break
            if j==len(node_id_list):
                break
    route_list= extractRoutes(node_id_list,Pred,model)
    return len(route_list),route_list

def calFitness(model):
    max_obj=-float('inf')
    best_sol=Sol()
    best_sol.obj=float('inf')

    # calculate travel distance and travel time
    for sol in model.sol_list:
        node_id_list=copy.deepcopy(sol.node_id_list)
        num_vehicle, route_list = splitRoutes(node_id_list, model)
        # travel cost
        timetable_list,cost_of_time,cost_of_distance,f1,f2 =calTravelCost(route_list,model)
        if model.opt_type == 0:
            sol.obj=cost_of_distance+f1+f2
        else:
            sol.obj=cost_of_time+f1+f2
        sol.route_list = route_list
        sol.timetable_list = timetable_list
        sol.cost_of_distance=cost_of_distance
        sol.cost_of_time=cost_of_time
        if sol.obj > max_obj:
            max_obj=sol.obj
        if sol.obj < best_sol.obj:
            best_sol=copy.deepcopy(sol)

    # calculate fitness
    for sol in model.sol_list:
        sol.fitness=max_obj-sol.obj
    if best_sol.obj<model.best_sol.obj:
        model.best_sol=copy.deepcopy(best_sol)

def generateInitialSol(model):
    demand_id_list=copy.deepcopy(model.demand_id_list)
    for i in range(model.popsize):
        seed=int(random.randint(0,10))
        random.seed(seed)
        random.shuffle(demand_id_list)
        sol=Sol()
        sol.node_id_list=copy.deepcopy(demand_id_list)
        model.sol_list.append(sol)

def selectSol(model):
    sol_list=copy.deepcopy(model.sol_list)
    model.sol_list=[]
    for i in range(model.n_select):
        f1_index=random.randint(0,len(sol_list)-1)
        f2_index=random.randint(0,len(sol_list)-1)
        f1_fit=sol_list[f1_index].fitness
        f2_fit=sol_list[f2_index].fitness
        if f1_fit<f2_fit:
            model.sol_list.append(sol_list[f2_index])
        else:
            model.sol_list.append(sol_list[f1_index])

def crossSol(model):
    sol_list=copy.deepcopy(model.sol_list)
    model.sol_list=[]
    while True:
        f1_index = random.randint(0, len(sol_list) - 1)
        f2_index = random.randint(0, len(sol_list) - 1)
        if f1_index!=f2_index:
            f1 = copy.deepcopy(sol_list[f1_index])
            f2 = copy.deepcopy(sol_list[f2_index])
            if random.random() <= model.pc:
                cro1_index=int(random.randint(0,len(model.demand_id_list)-1))
                cro2_index=int(random.randint(cro1_index,len(model.demand_id_list)-1))
                new_c1_f = []
                new_c1_m=f1.node_id_list[cro1_index:cro2_index+1]
                new_c1_b = []
                new_c2_f = []
                new_c2_m=f2.node_id_list[cro1_index:cro2_index+1]
                new_c2_b = []
                for index in range(len(model.demand_id_list)):
                    if len(new_c1_f)<cro1_index:
                        if f2.node_id_list[index] not in new_c1_m:
                            new_c1_f.append(f2.node_id_list[index])
                    else:
                        if f2.node_id_list[index] not in new_c1_m:
                            new_c1_b.append(f2.node_id_list[index])
                for index in range(len(model.demand_id_list)):
                    if len(new_c2_f)<cro1_index:
                        if f1.node_id_list[index] not in new_c2_m:
                            new_c2_f.append(f1.node_id_list[index])
                    else:
                        if f1.node_id_list[index] not in new_c2_m:
                            new_c2_b.append(f1.node_id_list[index])
                new_c1=copy.deepcopy(new_c1_f)
                new_c1.extend(new_c1_m)
                new_c1.extend(new_c1_b)
                f1.nodes_seq=new_c1
                new_c2=copy.deepcopy(new_c2_f)
                new_c2.extend(new_c2_m)
                new_c2.extend(new_c2_b)
                f2.nodes_seq=new_c2
                model.sol_list.append(copy.deepcopy(f1))
                model.sol_list.append(copy.deepcopy(f2))
            else:
                model.sol_list.append(copy.deepcopy(f1))
                model.sol_list.append(copy.deepcopy(f2))
            if len(model.sol_list)>model.popsize:
                break

def muSol(model):
    sol_list=copy.deepcopy(model.sol_list)
    model.sol_list=[]
    while True:
        f1_index = int(random.randint(0, len(sol_list) - 1))
        f1 = copy.deepcopy(sol_list[f1_index])
        m1_index=random.randint(0,len(model.demand_id_list)-1)
        m2_index=random.randint(0,len(model.demand_id_list)-1)
        if m1_index!=m2_index:
            if random.random() <= model.pm:
                node1=f1.node_id_list[m1_index]
                f1.node_id_list[m1_index]=f1.node_id_list[m2_index]
                f1.node_id_list[m2_index]=node1
                model.sol_list.append(copy.deepcopy(f1))
            else:
                model.sol_list.append(copy.deepcopy(f1))
            if len(model.sol_list)>model.popsize:
                break

def plotObj(obj_list):
    plt.rcParams['font.sans-serif'] = ['SimHei'] #show chinese
    plt.rcParams['axes.unicode_minus'] = False  # Show minus sign
    plt.plot(np.arange(1,len(obj_list)+1),obj_list)
    plt.xlabel('Iterations')
    plt.ylabel('Obj Value')
    plt.grid()
    plt.xlim(1,len(obj_list)+1)
    plt.show()

def outPut(model):
    work=xlsxwriter.Workbook('result.xlsx')
    worksheet=work.add_worksheet()
    worksheet.write(0, 0, 'cost_of_time')
    worksheet.write(0, 1, 'cost_of_distance')
    worksheet.write(0, 2, 'opt_type')
    worksheet.write(0, 3, 'obj')
    worksheet.write(1,0,model.best_sol.cost_of_time)
    worksheet.write(1,1,model.best_sol.cost_of_distance)
    worksheet.write(1,2,model.opt_type)
    worksheet.write(1,3,model.best_sol.obj)
    worksheet.write(2,0,'vehicleID')
    worksheet.write(2,1,'route')
    worksheet.write(2,2,'timetable')
    print("最优路径如下：")
    for row, route in enumerate(model.best_sol.route_list):
        r = [str(i) for i in route]
        r[0] = '0'
        r[-1] = ''
        print(''.join(r), end='')
    print('0')
    for row,route in enumerate(model.best_sol.route_list):
        worksheet.write(row+3,0,'v'+str(row+1))
        r=[str(i)for i in route]
        worksheet.write(row+3,1, '-'.join(r))
        print('-'.join(r))
        r=[str(i)for i in model.best_sol.timetable_list[row]]
        worksheet.write(row+3,2, '-'.join(r))
    work.close()


def plotRoutes(model):
    for route in model.best_sol.route_list:
        x_coord=[model.depot_dict[route[0]].x_coord]
        y_coord=[model.depot_dict[route[0]].y_coord]
        for node_id in route[1:-1]:
            x_coord.append(model.demand_dict[node_id].x_coord)
            y_coord.append(model.demand_dict[node_id].y_coord)
        x_coord.append(model.depot_dict[route[-1]].x_coord)
        y_coord.append(model.depot_dict[route[-1]].y_coord)
        plt.grid()
        if route[0]=='d1':
            plt.plot(x_coord,y_coord,marker='o',color='black',linewidth=0.5,markersize=5)
        elif route[0]=='d2':
            plt.plot(x_coord,y_coord,marker='o',color='orange',linewidth=0.5,markersize=5)
        else:
            plt.plot(x_coord,y_coord,marker='o',color='b',linewidth=0.5,markersize=5)
    plt.xlabel('x_coord')
    plt.ylabel('y_coord')
    plt.show()

def run(demand_file,depot_file,epochs,pc,pm,popsize,n_select,v_cap,v_speed,opt_type,customers_importance):
    """
    :param demand_file: demand file path
    :param depot_file: depot file path
    :param epochs: Iterations
    :param pc: Crossover probability
    :param pm: Mutation probability
    :param popsize: Population size
    :param n_select: Number of excellent individuals selected
    :param v_cap: Vehicle capacity
    :param v_speed: Vehicle free speed
    :param opt_type: Optimization type:0:Minimize the cost of travel distance;1:Minimize the cost of travel time
    ::param customers_importance: 重要客户序列编号
    :return:
    """
    model=Model()
    model.vehicle_cap=v_cap
    model.pc=pc
    model.pm=pm
    model.popsize=popsize
    model.n_select=n_select
    model.opt_type=opt_type
    model.customers_importance=customers_importance
    readCSVFile(demand_file,depot_file,model)
    calDistanceTimeMatrix(model)
    generateInitialSol(model)
    history_best_obj = []
    best_sol=Sol()
    best_sol.obj=float('inf')
    model.best_sol=best_sol
    for ep in range(epochs):
        calFitness(model)
        selectSol(model)
        crossSol(model)
        muSol(model)
        history_best_obj.append(model.best_sol.obj)
        print("%s/%s， best obj: %s" % (ep,epochs,model.best_sol.obj))
    plotObj(history_best_obj)
    plotRoutes(model)
    outPut(model)

if __name__=='__main__':
    demand_file='demand(1).csv'
    depot_file='depot.csv'
    customers_importance=[1,2,3,4,5,6,7,8,9,10]
    run(demand_file=demand_file,depot_file=depot_file,epochs=300,pc=0.8,pm=0.1,popsize=100,
        n_select=80,v_cap=80,v_speed=1,opt_type=0,customers_importance=customers_importance)


