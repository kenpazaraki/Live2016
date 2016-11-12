--創星神 ｔｉｅｒｒａ
--Tierra, Goddess of Rebirth
--Scripted by Eerie Code
function c91588074.initial_effect(c)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c91588074.spcon)
	e1:SetOperation(c91588074.spop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e2)
	--cannot special summon
	local e3=Effect.CreateEffect(c)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e3)
	--remove
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(91588074,0))
	e4:SetCategory(CATEGORY_TODECK)
	e4:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetTarget(c91588074.tdtg)
	e4:SetOperation(c91588074.tdop)
	c:RegisterEffect(e4)
end

function c91588074.spfil(c)
	return c:IsAbleToDeckOrExtraAsCost()
end
function c91588074.spfil2(c,tc,tp)
	if not c:IsAbleToDeckOrExtraAsCost() then return false end
	local g=Duel.GetMatchingGroup(c91588074.spfil,tp,LOCATION_HAND+LOCATION_ONFIELD,0,tc)
	g:Remove(Card.IsCode,nil,c:GetCode())
	return g:GetClassCount(Card.GetCode)>=9
end
function c91588074.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		local g=Duel.GetMatchingGroup(c91588074.spfil,tp,LOCATION_HAND+LOCATION_ONFIELD,0,c)
		return g:GetClassCount(Card.GetCode)>=10
	else
		return Duel.IsExistingMatchingCard(c91588074.spfil2,tp,LOCATION_MZONE,0,1,nil,c,tp)
	end
end
function c91588074.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.GetMatchingGroup(c91588074.spfil,tp,LOCATION_HAND+LOCATION_ONFIELD,0,c)
	local g=Group.CreateGroup()
	local n=10
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then
		n=9
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg=mg:FilterSelect(tp,Card.IsLocation,1,1,nil,LOCATION_MZONE)
		local cd=sg:GetFirst():GetCode()
		g:Merge(sg)
		mg:Remove(Card.IsCode,nil,cd)
	end
	for i=1,n do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg=mg:Select(tp,1,1,nil)
		local cd=sg:GetFirst():GetCode()
		g:Merge(sg)
		mg:Remove(Card.IsCode,nil,cd)
	end
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end

function c91588074.tdfil(c)
	return c:IsAbleToDeck() and ((c:IsFaceup() and c:IsType(TYPE_PENDULUM)) or not c:IsLocation(LOCATION_EXTRA))
end
function c91588074.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(c91588074.tdfil,tp,0x5e,0x5e,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
	Duel.SetChainLimit(aux.FALSE)
end
function c91588074.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c91588074.tdfil,tp,0x5e,0x5e,e:GetHandler())
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
end
