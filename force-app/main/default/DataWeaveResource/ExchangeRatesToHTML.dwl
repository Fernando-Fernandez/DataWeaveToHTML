%dw 2.0
input payload application/json
output application/xml writeDeclaration=false
---
div @(style:"height: 300px; overflow-y: scroll;"):
table @(style:"width: 50%; border: 1px solid gray; font-family: Arial"): { 
    thead @(style:"border: 1px solid gray; font-weight: bold"): 
        tr: { td: "Currency", td: "Rate" },
    tbody: ( payload.conversion_rates mapObject (
            (v, k) -> tr: { td: k, td: v } 
        ) 
    )
}