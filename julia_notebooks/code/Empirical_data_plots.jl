### A Pluto.jl notebook ###
# v0.20.3

using Markdown
using InteractiveUtils

# ╔═╡ 9d3db0a5-c59a-4877-8e35-d36c8605f806
begin
	println("This just calls the packages I am using")
	
	# essentials
	using PlutoUI
	using Distributions
	using Printf
	using Graphs
	using Random
	using LinearAlgebra
	using NearestCorrelationMatrix
	using Combinatorics
	using StatsBase
	using DSP
	
	# saving files
	using FileIO
	using JLD2
	
	# plotting
	using Plots
	using LaTeXStrings
	using CairoMakie
	using GraphMakie
	using NetworkLayout

	# python packages
	using NPZ
	using PyCall
	using CondaPkg
	using DataFrames
	
	# extra
	using BenchmarkTools
	using ProgressLogging
	using DelimitedFiles
end

# ╔═╡ 61026592-dc55-46bc-ae95-785b4c3b938c
const mk = CairoMakie

# ╔═╡ bce82737-a74a-4718-8858-d8df91b3d500
begin
	py"""
import numpy as np

def _load_dict_from_npy(filename):

	return np.load(filename, allow_pickle=True).item()
	"""

	_load_dict_from_npy = py"_load_dict_from_npy"
end

# ╔═╡ f59d2836-ab8c-438b-9427-8c56c4184dbd
"""
#### Returns:

`O_syn, O_red, U_syn, U_red, syn_nplets, red_nplets, individualID, order`

"""
function load_O_vs_U_FC_data(filename)

	res = _load_dict_from_npy(filename)

	# just reformat the nplets data store: from a matrix to a Vector{Vecotor}
	syn_nplets_mat = res["syn_nplets"]
	syn_nplets = []
	for i in 1:size(syn_nplets_mat)[1]
		push!(syn_nplets, syn_nplets_mat[i, :])
	end

	red_nplets_mat = res["red_nplets"]
	red_nplets = []
	for i in 1:size(red_nplets_mat)[1]
		push!(red_nplets, red_nplets_mat[i, :])
	end

	return res["O_syn"], res["O_red"], res["U_syn"], res["U_red"], syn_nplets, red_nplets, res["individualID"], res["order"]
end

# ╔═╡ b91d2dae-a4f5-48e2-a29f-55aa98eb6612
"""
#### Returns:

`order, Ω_data, U_data`
"""
function load_financial_O_vs_U_data(filename)

	data = npzread(filename)

	return data["order"], data["O_data"][:,1], data["U_data"]
end

# ╔═╡ 52087820-68df-11f0-1950-f5e3fa4674c2
function _res_brain_plot(fig, pos; legendfontsize=16, insetfontsize=16)
	ax = Axis(
		fig[pos[1],pos[2]], xlabel = L"\text{\text{energy-balance}\;U}",
		ylabel = L"\Omega", title = L"\textbf{resting-state fMRI}",
	)
	
	orders = [3,5,7,10]
	
	colors = Makie.wong_colors() # [end-length(orders):end]

	for (i, order) in enumerate(orders)
		
		filename = "/Users/ec627/Documents/Data/fMRI_data_powers_cognitive_tasks/thoi_data_analysis/individuals_greedy/individual_1_method_greedy_repeats_10000_order_$(order).npy"
	
		Ω_syn, Ω_red, U_syn, U_red, syn_nplets, red_nplets, individualID, order = load_O_vs_U_FC_data(filename)
	
		
		mk.scatter!(
			ax, U_syn, Ω_syn,
			color = colors[i], alpha=0.5,
			markersize = 15,
		)
		mk.scatter!(
			ax, U_red, Ω_red,
			color = colors[i], alpha=0.5,
			markersize = 15
		)
	end

	ax.xtickformat = x -> latexstring.(x)
	ax.ytickformat = x -> latexstring.(x)

	# plot legend (we need to use some dummy plots here...)
	for (i, order) in enumerate(orders)
		mk.scatter!(
			ax, [NaN], [NaN],
			color=colors[i], markersize = 15,
			label = L"%$(order)\text{-nplet}"
		)
	end
	axislegend(
		ax, position=:lt, labelsize = legendfontsize,patchlabelgap = 1,
		padding = (1.0f0, 4.0f0, 1.0f0, 1.0f0),
		framevisible = true
	)


	inset_ax = Axis(fig[pos[1],pos[2]];
                width  = Relative(0.35),      # 35 % of main cell
                height = Relative(0.35),
                halign = :right,              # horizontal alignment
                valign = :top,                # vertical   alignment
                xticklabelsize = insetfontsize,
                yticklabelsize = insetfontsize,
                # xlabel = L"U",
                # ylabel = L"\Omega"
	)

	for (i, order) in enumerate(orders)
		
		filename = "/Users/ec627/Documents/Data/fMRI_data_powers_cognitive_tasks/thoi_data_analysis/individuals_greedy/individual_1_method_greedy_repeats_10000_order_$(order).npy"
	
		Ω_syn, Ω_red, U_syn, U_red, syn_nplets, red_nplets, individualID, order = load_O_vs_U_FC_data(filename)
	
		
		mk.scatter!(
			inset_ax, U_syn, Ω_syn,
			color = colors[i], alpha=0.1,
			markersize = 5,
			# strokewidth=0.05,
			# strokecolor=:black
		)
	end

	mk.xlims!(ax, -0.7, 0.15)
	mk.xlims!(inset_ax, -0.02, 0.04)
	mk.ylims!(inset_ax, -0.3, 0.04)

	inset_ax.xticks=[0.0, 0.03]
	# inset_ax.yticks=[-0.02, 0.0, 0.02]

	inset_ax.xtickformat = x -> latexstring.(round.(x, digits = 3))
	inset_ax.ytickformat = x -> latexstring.(round.(x, digits = 3))

	return fig, ax, inset_ax
end

# ╔═╡ 9edb9b6d-c836-4f01-a03d-2b82264bc062
function _FX_rate_plot(fig, pos; legendfontsize=16, insetfontsize=16)
	
	ax = Axis(
		fig[pos[1],pos[2]], xlabel = L"\text{\text{energy-balance}\;U}",
		ylabel = L"\Omega", title = L"\textbf{FX rate}",
	)
	
	orders = [3,4,5,6,7]
	
	my_colors = [
		Makie.wong_colors()[1], # order 3
		:purple, 				# order 4
		Makie.wong_colors()[2], # order 5
		Makie.wong_colors()[5], # order 6
		Makie.wong_colors()[3], # order 7
		Makie.wong_colors()[4], # order 10 (for brain data only)
	]

	for (i, order) in enumerate(orders)
		
		filename="/Users/ec627/Documents/Data/financial_data_ananalysis/ForEx_N-886_P-9_2010-01-01-lr_order_$(order).npz"
	
		order, Ω_data, U_data = load_financial_O_vs_U_data(filename)
		
		mk.scatter!(
			ax, U_data, Ω_data,
			color = my_colors[i], alpha=0.5,
			markersize = 25,
		)
		
	end

	# plot legend (we need to use some dummy plots here...)
	orders_legend = [3,4,5,6,7,10]
	for (i, order) in enumerate(orders_legend)
		mk.scatter!(
			ax, [NaN], [NaN],
			color = my_colors[i], markersize = 15,
			label = L"%$(order)\text{-plet}"
		)
	end
	axislegend(
		ax, position=:lt, labelsize = legendfontsize,patchlabelgap = 1,
		padding = (1.0f0, 4.0f0, 1.0f0, 1.0f0),
		framevisible = true
	)
	# mk.translate!(leg.blockscene, 260, 120)
	# leg.backgroundcolor[] = RGBA(1,1,1,0)
	
	mk.xlims!(ax, -0.6, 0.2)

	ax.xtickformat = x -> latexstring.(round.(x, digits = 3))
	ax.ytickformat = x -> latexstring.(round.(x, digits = 3))


	###### start inset ######

	inset_ax = Axis(fig[pos[1],pos[2]];
                width  = Relative(0.35),      # 35 % of main cell
                height = Relative(0.35),
                halign = :right,              # horizontal alignment
                valign = :top,                # vertical   alignment
                xticklabelsize = insetfontsize,
                yticklabelsize = insetfontsize,
                # xlabel = L"U",
                # ylabel = L"\Omega"
				# yaxisposition = :right
	)

	for (i, order) in enumerate(orders)
		
		filename="/Users/ec627/Documents/Data/financial_data_ananalysis/ForEx_N-886_P-9_2010-01-01-lr_order_$(order).npz"
	
		order, Ω_data, U_data = load_financial_O_vs_U_data(filename)
		
		mk.scatter!(
			inset_ax, U_data, Ω_data,
			color = my_colors[i], alpha=0.8,
			markersize = 15,
		)
		
	end

	mk.xlims!(inset_ax, -0.012, 0.015)
	mk.ylims!(inset_ax, -0.03, 0.025)

	inset_ax.xticks=[-0.01, 0.0, 0.01]
	inset_ax.yticks=[-0.02, 0.0, 0.02]

	inset_ax.xtickformat = x -> latexstring.(round.(x, digits = 3))
	inset_ax.ytickformat = x -> latexstring.(round.(x, digits = 3))

	return fig, ax, inset_ax
end

# ╔═╡ 806001f1-3282-4e06-bcb4-fb7ef5d2e032
let
	println("Uncomment to plot")
	
	fig = Figure(size = (650, 450), fontsize = 24)
	fig, ax1, inset_ax1 = _FX_rate_plot(
		fig, (1,1); legendfontsize=14, insetfontsize=14
	)
	fig, ax2, inset_ax2 = _res_brain_plot(
		fig, (1,2); legendfontsize=14, insetfontsize=14
	)
	ax2.ylabel = ""
	colgap!(fig.layout, 10)

	ax1.xlabel = ""
	ax2.xlabel = ""

	Label(
		fig[2, 1:2],
		L"\text{balance-energy }U";
		fontsize = 24,
		halign   = :center,
		valign   = :top
	)

	rowgap!(fig.layout, 5)
	
	# add grid labels
	ga = fig[1, 1] = GridLayout()
	gb = fig[1, 2] = GridLayout()
	panellabels = [L"\textbf{(a)}", L"\textbf{(b)}"]
	for (label, layout) in zip(panellabels, [ga, gb])
	    Label(layout[1, 1, TopLeft()], label,
	        fontsize = 24,
	        # font = :bold,
	        padding = (0, 15, 5, 0),
	        halign = :right
		)
	end

	# save("/Users/ec627/Documents/Sussex/papers/PRL Synergistic Motifs/final_figures/main/fMRI_and_FX_figure.png", fig, px_per_unit=10)
	
	fig
end

# ╔═╡ Cell order:
# ╟─9d3db0a5-c59a-4877-8e35-d36c8605f806
# ╟─61026592-dc55-46bc-ae95-785b4c3b938c
# ╟─bce82737-a74a-4718-8858-d8df91b3d500
# ╟─f59d2836-ab8c-438b-9427-8c56c4184dbd
# ╟─b91d2dae-a4f5-48e2-a29f-55aa98eb6612
# ╟─52087820-68df-11f0-1950-f5e3fa4674c2
# ╟─9edb9b6d-c836-4f01-a03d-2b82264bc062
# ╟─806001f1-3282-4e06-bcb4-fb7ef5d2e032
