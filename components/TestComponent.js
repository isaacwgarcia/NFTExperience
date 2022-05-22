import React from "react";

export default function TestComponent() {
  return (
    <div className="bg-white py-32">
      <h1 className="flex justify-center text-4xl font-bold">
        Help People Fight Food Inflation Costs
      </h1>
      <div className="relative h-72">
        <div className="absolute top-12 -left-12 w-80 h-80 bg-gradient-to-r from-cyan-500 to-blue-500 rounded-full opacity-100"></div>
        <div className="absolute top-12 left-48 w-80 h-80 bg-gradient-to-r from-emerald-600 to-emerald-700 rounded-full opacity-100"></div>
        <div className="absolute top-12 -right-28 w-80 h-80 bg-gradient-to-r from-cyan-500 to-blue-500 rounded-full opacity-100"></div>
        <div className="absolute top-96 -right-0 font-bold text-xl">
          Full Cost
        </div>
        <div className="absolute top-96 left-20 font-bold text-xl">
          Food Bank
        </div>
      </div>
    </div>
  );
}
