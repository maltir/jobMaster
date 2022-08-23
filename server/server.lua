local VorpCore = {}

if Config.framework == "vorp" then
	TriggerEvent("getCore",function(core)
		VorpCore = core
	end)
end

RegisterServerEvent('jobMaster:startjob')
AddEventHandler('jobMaster:startjob', function(job)
	local _job = job
	if Config.framework == "redemrp" then 
		TriggerEvent('redemrp:getPlayerFromId', source, function(user)
        if user.getJob() == _job.jobName then
            TriggerClientEvent('jobMaster:start', source)
            serverNotification(source, Language.translate[Config.lang]['gopos'], 5)
        else
            serverNotification(source, Language.translate[Config.lang]['nojob'].._job.jobName, 5)
        end
    end)
	elseif Config.framework == "vorp" then
		local User = VorpCore.getUser(_source)
		local Character = User.getUsedCharacter
		if Character.job == _job.jobName then
            TriggerClientEvent('jobMaster:start', source)
            serverNotification(source, Language.translate[Config.lang]['gopos'], 5)
        else
            serverNotification(source, Language.translate[Config.lang]['nojob'].._job.jobName, 5)
        end
	end
    
end)

RegisterServerEvent('jobMaster:paid')
AddEventHandler('jobMaster:paid', function(money, xp)
	local _source = source
	if Config.framework == "redemrp" then 
		TriggerEvent('redemrp:getPlayerFromId', _source, function(user)
			user.addMoney(money)
			user.addXP(xp)
		end)
	elseif Config.framework == "vorp" then
		local User = VorpCore.getUser(_source)
		local Character = User.getUsedCharacter
		Character.addCurrency(0, money)
		Character.addXp(xp)
	end
end)


RegisterNetEvent("jobMaster:setJob")
AddEventHandler("jobMaster:setJob", function(jobname)
	local _jobname = jobname
	local _source = source
	if Config.framework == "redemrp" then
		TriggerEvent('redemrp:getPlayerFromId', _source, function(user)
			user.setJob(_jobname)
			user.setJobgrade(1)
		end)
	elseif Config.framework == "vorp" then
		local User = VorpCore.getUser(_source)
		local Character = User.getUsedCharacter
		Character.setJob(_jobname)
		Character.setJobGrade(1)
	end
end)

RegisterNetEvent("jobMaster:isJob")
AddEventHandler("jobMaster:isJob", function(jobname, callback)
	local _jobname = jobname
	local _source = source
	if Config.framework == "redemrp" then
		TriggerEvent('redemrp:getPlayerFromId', _source, function(user)
			if user.getJob() == _jobname then
				callback(true)
			else
				callback(false)
			end
		end)
	elseif Config.framework == "vorp" then
		local User = VorpCore.getUser(_source)
		local Character = User.getUsedCharacter
		if Character.job == _jobname then
			callback(true)
		else
			callback(false)
		end
	end
end)

function serverNotification(_source, text, notifTime)
	if Config.framework == "redemrp" then
		TriggerClientEvent("redemrp_notification:start", _source, text, notifTime)
	elseif Config.framework == "vorp" then
		TriggerClientEvent("vorp:TipRight", _source, text, notifTime)
	end
end